-- ------------------------------------------------------------------------------
-- undotree (mbbill/undotree) — Visualize and jump in undo tree
-- ------------------------------------------------------------------------------
-- What it does: Opens a sidebar showing the undo tree; jump to any past state.
--   <leader>u would conflict if we used one key; we use <leader>uu (u = undo).
-- Keymaps: <leader>uu — toggle undotree (leader+u was free; we use uu for mnemonic).
-- Notes: No conflict with leader+uh (inlay hints) or leader+un (notify dismiss in noice).
-- ------------------------------------------------------------------------------

return {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	keys = {
		{ "<leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undotree: toggle" },
	},
	config = function()
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
