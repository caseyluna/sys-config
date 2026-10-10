-- ------------------------------------------------------------------------------
-- snacks.nvim (folke/snacks.nvim) — Small QoL modules (dashboard, buffer delete)
-- ------------------------------------------------------------------------------
-- What it does: Start screen with quick actions (replaces alpha-nvim), smart
--   buffer delete that keeps the window layout, big-file guard, fast file open.
--   Also a dependency of claudecode.nvim.
-- Keymaps: dashboard letters shown on screen · <leader>bd close buffer
-- Notes: To enable more modules (picker, notifier, zen…) add them to opts.
-- ------------------------------------------------------------------------------

local function greeting()
	local hour = tonumber(os.date("%H"))
	local word = hour < 5 and "Still up?"
		or hour < 12 and "Good morning"
		or hour < 17 and "Good afternoon"
		or "Good evening"
	return word .. "  ·  " .. os.date("%A, %B %d")
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Close buffer (keep layout)",
		},
	},
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = greeting(),
				keys = {
					{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{ icon = " ", key = "e", desc = "Explorer", action = ":Neotree toggle" },
					{ icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
					{ icon = " ", key = "F", desc = "Git files", action = ":Telescope git_files" },
					{ icon = " ", key = "w", desc = "Find word", action = ":Telescope live_grep" },
					{ icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
					{ icon = " ", key = "b", desc = "Git branches", action = ":Telescope git_branches" },
					{ icon = " ", key = "g", desc = "Lazygit", action = ":LazyGit" },
					{ icon = " ", key = "s", desc = "Restore session", section = "session" },
					{ icon = " ", key = "t", desc = "Todos", action = ":TodoTelescope" },
					{ icon = "󰒲 ", key = "p", desc = "Plugins", action = ":Lazy" },
					{ icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
