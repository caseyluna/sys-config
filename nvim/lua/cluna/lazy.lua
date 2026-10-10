-- ------------------------------------------------------------------------------
-- lazy.lua — Plugin manager (lazy.nvim) bootstrap and config
-- ------------------------------------------------------------------------------
-- What it does:
--   Clones lazy.nvim on first run, then loads every spec from lua/cluna/plugins/
--   (each file is auto-imported). Disables unused built-in plugins.
--
-- How to interact:
--   Add a plugin: create lua/cluna/plugins/<name>.lua returning a lazy spec.
--   :Lazy to manage; :Lazy sync after editing specs. Headless bootstrap (used
--   by setup.sh): nvim --headless "+Lazy! sync" +qa
--
-- Location: ~/.config/nvim/lua/cluna/lazy.lua
-- ------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "cluna.plugins" },
}, {
	checker = { enabled = true, notify = false, frequency = 86400 }, -- check for updates once a day
	change_detection = { notify = false },
	install = { missing = true, colorscheme = { "catppuccin-mocha" } },
	rocks = { enabled = false }, -- no luarocks-dependent plugins; avoids hererocks health errors
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
