-- ------------------------------------------------------------------------------
-- indent-blankline.nvim (lukas-reineke/indent-blankline.nvim) — Indent guides
-- ------------------------------------------------------------------------------
-- What it does: Draws vertical lines at each indent level (char '┊') and can
--   highlight the current scope. Excludes help, terminal, Telescope, etc.
-- Keymaps: :IBLToggle to show/hide indent lines.
-- Notes: Scope highlighting uses Treesitter when available.
-- ------------------------------------------------------------------------------

return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "┊", -- Character used to draw indent lines
			tab_char = nil,
		},
		scope = {
			enabled = true, -- Highlight current scope (based on Treesitter)
			show_start = false,
			show_end = false,
		},
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"lazy",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
				"mason",
			},
			buftypes = { "terminal", "nofile" },
		},
	},
}
