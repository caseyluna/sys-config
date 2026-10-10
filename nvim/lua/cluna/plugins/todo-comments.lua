-- ------------------------------------------------------------------------------
-- todo-comments.nvim (folke/todo-comments.nvim) — TODO/FIXME highlight and search
-- ------------------------------------------------------------------------------
-- What it does: Highlights TODO, FIX, HACK, WARN, NOTE, etc. in comments and
--   provides navigation and Telescope search. Uses Treesitter or regex.
-- Keymaps: ]t [t (next/prev todo), :TodoTelescope (search; <leader>ft in telescope.lua).
-- Notes: Keywords and colors in setup(); search uses rg. Depends on plenary.
-- ------------------------------------------------------------------------------

return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")

		todo_comments.setup({
			signs = true, -- show signs in the gutter
			highlight = {
				keyword = "wide", -- highlight entire line or just keyword ("wide", "foreground", "background")
				after = "", -- disable highlighting after keyword
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS):]], -- regex to match keywords
			},
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIMIZE", "PERFORMANCE", "BENCHMARK" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		})

		-- Keymaps for navigation
		local keymap = vim.keymap
		keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "Jump to next todo comment" })

		keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "Jump to previous todo comment" })
	end,
}
