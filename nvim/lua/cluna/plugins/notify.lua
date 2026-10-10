-- ------------------------------------------------------------------------------
-- nvim-notify (rcarriga/nvim-notify) — Notification popups
-- ------------------------------------------------------------------------------
-- What it does: Replaces vim.notify() with a styled notification popup. Used
--   by LSP and other plugins; noice.nvim can style it further.
-- Keymaps: <leader>un — dismiss notifications (noice may add); none by default.
-- Notes: Load early; noice depends on this. No conflict with existing keys.
-- ------------------------------------------------------------------------------

return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	opts = {
		background_colour = "#1e1e2e",
		fps = 30,
		level = 2,
		minimum_width = 50,
		render = "default",
		stages = "fade_in_slide_out",
		timeout = 3000,
		top_down = true,
	},
}
