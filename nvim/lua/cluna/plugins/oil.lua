-- ------------------------------------------------------------------------------
-- oil.nvim (stevearc/oil.nvim) — Edit filesystem as a buffer
-- ------------------------------------------------------------------------------
-- What it does: Open a directory in a buffer; rename, create, delete files like
--   editing text. <leader>o to open oil (no conflict; leader+o free).
-- Keymaps: <leader>o — open oil for current file's directory.
-- Notes: - in oil buffer goes up a dir. Works alongside neo-tree (ee = explorer, o = oil).
-- ------------------------------------------------------------------------------

return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	opts = {
		columns = { "icon", "permissions", "size", "mtime" },
		view_options = { show_hidden = true },
	},
	keys = {
		{ "<leader>o", "<cmd>Oil<CR>", desc = "Oil: edit directory" },
	},
}
