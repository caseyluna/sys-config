-- ------------------------------------------------------------------------------
-- conform.nvim (stevearc/conform.nvim) — Format on save and on demand
-- ------------------------------------------------------------------------------
-- What it does: Runs the formatter for the current filetype on save (falls back
--   to the LSP's formatter). Formatters are installed by Mason (mason.lua).
-- Keymaps: <leader>mp — format buffer (normal) or selection (visual)
-- Notes: .shrc files are treated as shell. Errors are shown (notify_on_error)
--   so a missing formatter is never silent.
-- ------------------------------------------------------------------------------

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({ lsp_format = "fallback", async = false, timeout_ms = 2000 })
			end,
			mode = { "n", "v" },
			desc = "Format buffer / selection",
		},
	},
	init = function()
		vim.filetype.add({ extension = { shrc = "sh" } })
	end,
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			python = { "ruff_organize_imports", "ruff_format" },
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			sql = { "sqlfluff" },
			terraform = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
			hcl = { "terraform_fmt" },
			toml = { "taplo" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
		},
		formatters = {
			shfmt = { prepend_args = { "-i", "2", "-ci" } }, -- 2-space indent, indent case branches
			sqlfluff = { args = { "format", "--dialect", "ansi", "-" } },
		},
		format_on_save = { lsp_format = "fallback", timeout_ms = 2000 },
	},
}
