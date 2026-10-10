-- ------------------------------------------------------------------------------
-- which-key.nvim (folke/which-key.nvim) — Keymap popup + group labels
-- ------------------------------------------------------------------------------
-- What it does: Press <leader> (or any prefix) and pause to see what's bound.
--   The spec below only names the groups; the keymaps themselves live in each
--   plugin file. When you add a new <leader>x prefix, add its label here.
-- Keymaps: <leader>? — show keymaps for the current buffer
-- ------------------------------------------------------------------------------

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>a", group = "harpoon" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "claude" },
			{ "<leader>d", group = "debug" },
			{ "<leader>e", group = "explorer" },
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>h", group = "hunks" },
			{ "<leader>i", group = "octo issue", mode = { "n" } },
			{ "<leader>l", group = "lazygit" },
			{ "<leader>m", group = "format/lint" },
			{ "<leader>p", group = "octo pr" },
			{ "<leader>q", group = "session" },
			{ "<leader>r", group = "rename/refactor/outline" },
			{ "<leader>s", group = "splits" },
			{ "<leader>S", group = "search/replace" },
			{ "<leader>t", group = "tabs/terminal" },
			{ "<leader>T", group = "tests" },
			{ "<leader>u", group = "ui/undo" },
			{ "<leader>x", group = "trouble" },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer-local keymaps",
		},
	},
}
