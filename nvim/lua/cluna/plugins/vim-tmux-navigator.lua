-- ------------------------------------------------------------------------------
-- nvim-tmux-navigation (alexghergh/nvim-tmux-navigation) — Pane/split nav
-- ------------------------------------------------------------------------------
-- What it does: <C-h/j/k/l> move focus between Neovim splits and tmux panes.
--   Single source for these keys (core keymaps.lua does not define them).
-- Keymaps: <C-h> (left), <C-j> (down), <C-k> (up), <C-l> (right).
-- Notes: Requires tmux with vim-tmux-navigator plugin and matching bindings.
-- ------------------------------------------------------------------------------

return {
	"alexghergh/nvim-tmux-navigation",
	lazy = false,
	config = function()
		local nav = require("nvim-tmux-navigation")

		nav.setup({
			disable_when_zoomed = true, -- When tmux pane is zoomed, don't navigate out of it
		})

		local map = vim.keymap.set
		local opts = { silent = true, noremap = true, desc = "Tmux/split navigation" }

		map("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", opts)
		map("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", opts)
		map("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", opts)
		map("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", opts)
	end,
}
