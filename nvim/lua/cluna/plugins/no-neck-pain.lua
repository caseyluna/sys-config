-- ------------------------------------------------------------------------------
-- no-neck-pain.nvim (shortcuts/no-neck-pain.nvim) — Center buffer with padding
-- ------------------------------------------------------------------------------
-- What it does: When the window is wide, keeps the current buffer centered with
--   side padding so you don't look at the far edges of a large monitor.
-- Keymaps: <leader>z — toggle (we use leader+z; no existing conflict).
-- Notes: Disable per filetype in opts if needed (e.g. terminal, neo-tree).
-- ------------------------------------------------------------------------------

return {
	"shortcuts/no-neck-pain.nvim",
	cmd = "NoNeckPain",
	keys = {
		{ "<leader>z", "<cmd>NoNeckPain<CR>", desc = "Toggle NoNeckPain (center buffer)" },
	},
	opts = {
		width = 120,
		disableOnLastBuffer = true,
		buffers = {
			right = { enabled = false },
			left = { enabled = false },
		},
	},
}
