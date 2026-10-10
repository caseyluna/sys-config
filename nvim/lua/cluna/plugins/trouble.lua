-- ------------------------------------------------------------------------------
-- trouble.nvim (folke/trouble.nvim) — Diagnostics / quickfix / references panel
-- ------------------------------------------------------------------------------
-- Keymaps (under <leader>x):
--   xx toggle project diagnostics   xd buffer diagnostics   xq quickfix
--   xl loclist   xt todos   xr LSP references/definitions
-- ------------------------------------------------------------------------------

return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: project diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble: buffer diagnostics" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: quickfix" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: loclist" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Trouble: todos" },
		{ "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble: LSP refs/defs" },
	},
	opts = { focus = true, auto_preview = true },
}
