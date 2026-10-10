-- ------------------------------------------------------------------------------
-- bufferline.nvim (akinsho/bufferline.nvim) — Open buffers as tabs at the top
-- ------------------------------------------------------------------------------
-- Keymaps: <Tab> / <S-Tab> or ]b / [b next / previous buffer · <leader>bd close
--   buffer (snacks.lua)
-- Notes: <Tab> and <C-i> (jumplist forward) are separate keys only because
--   Ghostty + tmux `extended-keys` send CSI u; without that, <Tab> would
--   shadow <C-i>.
-- ------------------------------------------------------------------------------

return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
		{ "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
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
