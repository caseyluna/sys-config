-- ------------------------------------------------------------------------------
-- nvim-autopairs (windwp/nvim-autopairs) — Auto-close brackets and quotes
-- ------------------------------------------------------------------------------
-- What it does: Typing an opener inserts the closer; Treesitter-aware so it
--   doesn't pair inside strings. Works independently of the completion menu.
-- Keymaps: none.
-- ------------------------------------------------------------------------------

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true,
		ts_config = { lua = { "string" } },
	},
}
