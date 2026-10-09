-- ------------------------------------------------------------------------------
-- bufferline.nvim (akinsho/bufferline.nvim) — Open buffers as tabs at the top
-- ------------------------------------------------------------------------------
-- Keymaps: ]b / [b next / previous buffer · <leader>bd close buffer (snacks.lua)
-- Notes: <Tab> is NOT used here — it is <C-i> (jumplist forward) in Vim.
-- ------------------------------------------------------------------------------

return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
		{ "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
	},
	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
			show_close_icon = false,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			offsets = { { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" } },
		},
	},
}
