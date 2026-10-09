-- ------------------------------------------------------------------------------
-- gitsigns.nvim (lewis6991/gitsigns.nvim) — Git signs and hunk actions
-- ------------------------------------------------------------------------------
-- What it does: Shows added/modified/deleted lines in the sign column; stage or
--   reset hunks, blame, and diff from the buffer. Text object `ih` for hunks.
-- Keymaps: ]h [h (hunks), <leader>hs/hr (stage/reset), <leader>hB (blame), <leader>hp/hd.
-- Notes: Buffer-local keymaps set in on_attach below.
-- ------------------------------------------------------------------------------

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- 📍 Navigation
			map("n", "]h", function()
				gs.nav_hunk("next")
			end, "Next hunk")
			map("n", "[h", function()
				gs.nav_hunk("prev")
			end, "Previous hunk")

			-- 🛠️ Actions on Hunks
			map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage selected hunk")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset selected hunk")

			-- 📦 Buffer-wide Actions
			map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

			-- ↩️ Undo
			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

			-- 👀 Preview
			map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

			-- 🕵️ Blame
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Blame line (full)")
			map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

			-- 🧾 Diffs
			map("n", "<leader>hd", gs.diffthis, "Diff this")
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, "Diff with ~")

			-- 🎯 Text Object for Hunks
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
		end,
	},
}
