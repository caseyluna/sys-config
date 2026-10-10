-- ------------------------------------------------------------------------------
-- noice.nvim (folke/noice.nvim) — Cmdline, search, and message UI
-- ------------------------------------------------------------------------------
-- What it does: Replaces the default cmdline, search (/) and messages with a
--   minimal popup UI. Less flicker; works with nvim-notify for notifications.
-- Keymaps: Default noice keymaps (e.g. scroll in popup); no leader conflict.
-- Notes: Depends on nvim-notify and nui.nvim. Load after notify.
-- ------------------------------------------------------------------------------

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		cmdline = { enabled = true },
		messages = { enabled = true },
		notify = { view = "notify" },
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			lsp_doc_border = true,
		},
	},
}
