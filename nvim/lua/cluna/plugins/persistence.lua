-- ------------------------------------------------------------------------------
-- persistence.nvim (folke/persistence.nvim) — Sessions per directory
-- ------------------------------------------------------------------------------
-- What it does: Saves the session (buffers, layout) on exit, keyed by cwd, so
--   `nvim` in a project restores where you left off.
-- Keymaps (under <leader>q):
--   qs restore for cwd   ql restore last   qS pick a session   qd don't save this session
-- ------------------------------------------------------------------------------

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Session: restore (cwd)",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Session: restore last",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Session: select",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Session: don't save on exit",
		},
	},
	opts = {},
}
