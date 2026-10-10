-- ------------------------------------------------------------------------------
-- smoke/nvim.lua — Headless Neovim probe for scripts/smoke.py
-- ------------------------------------------------------------------------------
-- What it does:
--   Loaded with --cmd (before init.lua) so it can wrap vim.keymap.set and
--   nvim_set_keymap and record WHO defines every global mapping. On VimEnter it
--   force-loads every plugin (so config-time and plugin-default maps exist),
--   opens one sample file per language, waits for LSP, then writes JSON to
--   $SMOKE_OUT and quits:
--     maps   — {mode, lhs, src} per definition (lazy `keys` specs: src=lazy:<plugin>)
--     errors — error messages raised during startup / plugin load / file open
--     warns  — vim.notify WARN+ (deprecations etc.)
--     lsp    — {ft, expected = {server...}, attached = {client...}}
-- Run via: python3 scripts/smoke.py  (not meant to be used directly)
-- ------------------------------------------------------------------------------

local out_path = assert(os.getenv("SMOKE_OUT"), "SMOKE_OUT not set")
local repo_nvim = vim.uv.fs_realpath(assert(os.getenv("SMOKE_REPO"))) .. "/nvim/"
local result = { maps = {}, errors = {}, warns = {}, lsp = {} }

local function norm(lhs)
	return vim.fn.keytrans(vim.keycode(lhs))
end

local real = {}
local function realpath(path) -- config is loaded through a symlink → repo
	if real[path] == nil then
		real[path] = vim.uv.fs_realpath(path) or path
	end
	return real[path]
end

-- Who called vim.keymap.set: first frame in this repo's config, else the plugin
-- dir it came from. Calls from lazy.nvim's keys handler are skipped here — those
-- are collected from the specs (with the plugin name) in collect_lazy_keys().
local function caller()
	for level = 3, 30 do
		local info = debug.getinfo(level, "Sl")
		if not info then
			break
		end
		local src = realpath(info.source:sub(2))
		if src:find("lazy.nvim/lua/lazy/core/handler/keys", 1, true) then
			return nil
		end
		if src:find(repo_nvim, 1, true) then
			return src:sub(#repo_nvim + 1) .. ":" .. info.currentline
		end
		local plugin = src:match("/lazy/([^/]+)/") or src:match("/pack/[^/]+/[^/]+/([^/]+)/")
		if plugin and plugin ~= "lazy.nvim" then
			return "plugin:" .. plugin
		end
	end
	return nil -- Neovim runtime defaults
end

local function record(modes, lhs, opts)
	if opts and opts.buffer and opts.buffer ~= false then
		return -- buffer-local maps are intentional per-filetype overrides
	end
	local src = caller()
	if not src then
		return
	end
	for _, m in ipairs(type(modes) == "table" and modes or { modes }) do
		m = m == "" and "nvo" or m
		for c in m:gmatch(".") do -- "nvo" / "v" → n,x,s,o …
			local ms = c == "v" and { "x", "s" } or (c == "o" and m == "nvo" and { "o" } or { c })
			for _, mm in ipairs(ms) do
				table.insert(result.maps, { mode = mm, lhs = norm(lhs), src = src })
			end
		end
	end
end

local set = vim.keymap.set
vim.keymap.set = function(modes, lhs, rhs, opts)
	pcall(record, modes, lhs, opts)
	return set(modes, lhs, rhs, opts)
end
local api_set = vim.api.nvim_set_keymap
vim.api.nvim_set_keymap = function(mode, lhs, rhs, opts)
	pcall(record, mode, lhs, nil)
	return api_set(mode, lhs, rhs, opts)
end

local notify = vim.notify
vim.notify = function(msg, level, opts)
	if (level or 0) >= vim.log.levels.WARN then
		local list = level >= vim.log.levels.ERROR and result.errors or result.warns
		table.insert(list, "notify: " .. tostring(msg):gsub("\n.*", ""))
	end
	return notify(msg, level, opts)
end
vim.deprecate = function(name, alt, version, plugin)
	table.insert(
		result.warns,
		("deprecated: %s → %s (%s, removed in %s)"):format(name, alt or "?", plugin or "nvim", version or "?")
	)
end

local function err(where, msg)
	table.insert(result.errors, where .. ": " .. tostring(msg):gsub("\n.*", ""))
end

local function collect_lazy_keys()
	local ok, Config = pcall(require, "lazy.core.config")
	if not ok then
		return err("lazy", "lazy.nvim not available")
	end
	local Keys = require("lazy.core.handler.keys")
	local Plugin = require("lazy.core.plugin")
	for name, plugin in pairs(Config.plugins) do
		for _, k in pairs(Keys.resolve(Plugin.values(plugin, "keys", true))) do
			if k.rhs ~= nil and not k.ft then -- rhs-less entries are load triggers only
				for _, m in ipairs(type(k.mode) == "table" and k.mode or { k.mode or "n" }) do
					m = m == "v" and "x" or m
					table.insert(result.maps, { mode = m, lhs = norm(k.lhs), src = "lazy:" .. name })
				end
			end
		end
	end
end

-- One sample per language this config supports; servers come from vim.lsp.config.
local samples = {
	python = "x = 1\n",
	sh = "#!/usr/bin/env bash\necho hi\n",
	sql = "select 1;\n",
	terraform = 'variable "x" {}\n',
	lua = "local x = 1\n",
	markdown = "# hi\n",
}
local ext = { python = "py", sh = "sh", sql = "sql", terraform = "tf", lua = "lua", markdown = "md" }

local function expected_servers(ft)
	local names = {}
	for name, cfg in pairs(vim.lsp._enabled_configs or {}) do
		cfg = vim.lsp.config[name] or cfg
		local cmd = cfg and cfg.cmd
		if cfg and vim.tbl_contains(cfg.filetypes or {}, ft) and type(cmd) == "table" then
			if vim.fn.executable(cmd[1]) == 1 then -- only expect servers that are installed
				table.insert(names, name)
			end
		end
	end
	table.sort(names)
	return names
end

local function finish()
	local f = assert(io.open(out_path, "w"))
	f:write(vim.json.encode(result))
	f:close()
	vim.cmd("qa!")
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.schedule(function()
			-- Load every plugin so config-time and default maps are recorded.
			local ok, lazy = pcall(require, "lazy")
			if ok then
				local names = vim.tbl_map(function(p)
					return p.name
				end, lazy.plugins())
				local lok, lerr = pcall(lazy.load, { plugins = names })
				if not lok then
					err("Lazy load", lerr)
				end
				collect_lazy_keys()
			end
			local dir = vim.fn.tempname()
			vim.fn.mkdir(dir, "p")
			local fts = vim.tbl_keys(samples)
			table.sort(fts)
			for _, ft in ipairs(fts) do
				local path = dir .. "/sample." .. ext[ft]
				vim.fn.writefile(vim.split(samples[ft], "\n"), path)
				local eok, eerr = pcall(vim.cmd.edit, path)
				if not eok then
					err("open ." .. ext[ft], eerr)
				end
				local want = expected_servers(ft)
				local buf = vim.api.nvim_get_current_buf()
				vim.wait(#want > 0 and 8000 or 0, function()
					for _, name in ipairs(want) do
						if #vim.lsp.get_clients({ bufnr = buf, name = name }) == 0 then
							return false
						end
					end
					return true
				end, 100)
				local got = vim.tbl_map(function(c)
					return c.name
				end, vim.lsp.get_clients({ bufnr = buf }))
				table.sort(got)
				table.insert(result.lsp, { ft = ft, expected = want, attached = got })
			end
			-- Errors that were reported via messages rather than thrown.
			for _, line in ipairs(vim.split(vim.fn.execute("messages"), "\n")) do
				if line:match("^E%d+:") or line:match("^Error") or line:match("stack traceback") then
					err("messages", line)
				end
			end
			finish()
		end)
	end,
})
