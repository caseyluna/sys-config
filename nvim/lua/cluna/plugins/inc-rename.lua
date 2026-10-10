-- ------------------------------------------------------------------------------
-- inc-rename.nvim (smjonas/inc-rename.nvim) — Inline rename preview
-- ------------------------------------------------------------------------------
-- What it does: When you trigger LSP rename (<leader>rn), shows an inline
--   preview as you type. lspconfig.lua calls IncRename from <leader>rn when this is loaded.
-- Keymaps: <leader>rn (set in lspconfig LspAttach to use this when available).
-- Notes: No keymap set here; lspconfig checks for inc_rename and uses it.
-- ------------------------------------------------------------------------------

return {
	"smjonas/inc-rename.nvim",
	event = "LspAttach",
	opts = {},
	config = function(_, opts)
		require("inc_rename").setup(opts)
	end,
}
