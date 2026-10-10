-- ------------------------------------------------------------------------------
-- flash.nvim (folke/flash.nvim) — Label-based jump (EasyMotion-style)
-- ------------------------------------------------------------------------------
-- What it does: Press a key (we use <leader>j), then type a label to jump the
--   cursor to any visible position.
-- Keymaps: <leader>j (jump; no conflict with existing leader keys).
-- Notes: Can also use in remote (tmux/ssh) with opts. Search mode: optional.
-- ------------------------------------------------------------------------------

return {
	"folke/flash.nvim",
	opts = {},
	keys = {
		{
			"<leader>j",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash: jump to label",
		},
	},
}
