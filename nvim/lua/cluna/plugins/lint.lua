-- ------------------------------------------------------------------------------
-- nvim-lint (mfussenegger/nvim-lint) — Linters that aren't language servers
-- ------------------------------------------------------------------------------
-- What it does: Runs external linters and shows results as diagnostics
--   (alongside LSP diagnostics). Triggers after save, on open, and when leaving
--   insert mode. Linters are installed by Mason (mason.lua) or Brewfile.
-- Keymaps: <leader>ml — lint the current buffer now
-- Notes: ruff lints via its LSP (lspconfig.lua), so it isn't listed here.
-- ------------------------------------------------------------------------------

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	keys = {
		{
			"<leader>ml",
			function()
				require("lint").try_lint()
			end,
			desc = "Lint buffer",
		},
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "mypy" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			sql = { "sqlfluff" },
			markdown = { "markdownlint" },
			dockerfile = { "hadolint" },
			yaml = { "yamllint" },
		}

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("cluna_lint", { clear = true }),
			callback = function()
				-- Only lint real files (skip terminals, prompts, etc.)
				if vim.bo.buftype == "" then
					lint.try_lint()
				end
			end,
		})
	end,
}
