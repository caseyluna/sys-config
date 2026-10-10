-- ------------------------------------------------------------------------------
-- diffview.nvim (sindrets/diffview.nvim) — Git diff and merge conflict UI
-- ------------------------------------------------------------------------------
-- What it does: Opens a rich diff view for any git range, a file history panel
--   for blame-style exploration, and a 3-way merge conflict editor with layout
--   controls. Replaces the need for external diff tools during code review.
-- Keymaps:
--   <leader>gd  — diff working tree vs HEAD (DiffviewOpen)
--   <leader>gh  — file history for current buffer
--   <leader>gH  — file history for entire repo
--   <leader>gc  — close diffview (DiffviewClose)
-- Notes: Lazy-loaded on keymaps and commands; zero startup cost.
-- Depends on: nvim-web-devicons (icons), plenary.nvim (async).
-- ------------------------------------------------------------------------------

return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: open diff (HEAD)" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: file history" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview: repo history" },
		{ "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview: close" },
	},
	opts = {
		enhanced_diff_hl = true, -- use treesitter for inline diff highlights

		view = {
			-- 3-way layout for merge conflicts: ours | result | theirs
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true,
			},
		},

		hooks = {
			diff_buf_read = function(bufnr)
				vim.opt_local.wrap = false
				vim.opt_local.list = false
				vim.opt_local.colorcolumn = ""
			end,
		},
	},
}
