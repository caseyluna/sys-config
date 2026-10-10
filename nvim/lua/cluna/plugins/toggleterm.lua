-- ------------------------------------------------------------------------------
-- toggleterm.nvim (akinsho/toggleterm.nvim) — Floating/split terminal
-- ------------------------------------------------------------------------------
-- What it does: Toggle a terminal in a float or split. <leader>tt toggles;
--   no conflict with leader+t (tabs use to, tx, tn, tp, tf — two keys).
-- Keymaps: <leader>tt (toggle terminal), <leader>tf already used for tab — so tt only.
-- Notes: Can add more terminals (e.g. lazygit in term) via opts or keymaps.
-- ------------------------------------------------------------------------------

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = "ToggleTerm",
	opts = {
		open_mapping = false,
		direction = "float",
		float_opts = { border = "rounded" },
		shade_terminals = true,
		start_in_insert = true,
	},
	keys = {
		{ "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
	},
}
