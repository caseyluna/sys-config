-- ------------------------------------------------------------------------------
-- neo-tree.nvim (nvim-neo-tree/neo-tree.nvim) — File and buffer explorer
-- ------------------------------------------------------------------------------
-- What it does: File tree, buffer list, and git status in a float or sidebar.
--   Replaces netrw; supports filtering and follow-current-file.
-- Keymaps: <leader>ee files · <leader>eg git status · <leader>bf buffers (all floating)
-- Notes: Lazy-loads on first keymap. Directory *editing* is oil (<leader>o).
-- ------------------------------------------------------------------------------

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	keys = {
		{ "<leader>ee", "<cmd>Neotree filesystem reveal float<CR>", desc = "Explorer: files" },
		{ "<leader>eg", "<cmd>Neotree git_status reveal float<CR>", desc = "Explorer: git status" },
		{ "<leader>bf", "<cmd>Neotree buffers reveal float<CR>", desc = "Explorer: buffers" },
	},
	dependencies = {
		"s1n7ax/nvim-window-picker",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true, -- Show hidden and gitignored files
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = { enabled = true }, -- auto-focus on current file
			},
			buffers = {
				follow_current_file = true,
			},
			git_status = {
				window = {
					position = "float",
				},
			},
			window = {
				position = "float",
				popup = {
					size = {
						height = "80%",
						width = "60%",
					},
					border = "rounded",
				},
				mappings = {
					["o"] = "open",
					["<cr>"] = "open_with_window_picker",
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})
	end,
}
