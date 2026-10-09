-- ------------------------------------------------------------------------------
-- mason.nvim (mason-org/mason.nvim) — installs LSP servers, formatters, linters
-- ------------------------------------------------------------------------------
-- What it does: On startup ensures every server in lspconfig.lua and every
--   formatter/linter/debugger used by formatting.lua, lint.lua and dap.lua is
--   installed under ~/.local/share/nvim/mason. :Mason opens the UI.
-- Notes: automatic_enable is OFF — lspconfig.lua decides what to enable, so a
--   formatter like stylua is never started as a language server.
--   Headless (setup.sh): nvim --headless "+MasonToolsInstallSync" +qa
-- ------------------------------------------------------------------------------

return {
	"mason-org/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
		})

		-- Language servers (names = lspconfig names; must match lspconfig.lua)
		require("mason-lspconfig").setup({
			automatic_enable = false,
			ensure_installed = {
				"pyright",
				"ruff",
				"lua_ls",
				"bashls",
				"terraformls",
				"dockerls",
				"yamlls",
				"jsonls",
				"taplo",
				"sqlls",
				"marksman",
				"html",
				"cssls",
			},
		})

		-- Formatters, linters, debug adapters (names = Mason package names)
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua", -- lua format
				"shfmt", -- shell format
				"shellcheck", -- shell lint
				"prettier", -- json/yaml/md/html/css format
				"sqlfluff", -- sql format + lint
				"markdownlint", -- markdown lint/fix
				"mypy", -- python type lint
				"debugpy", -- python debug adapter
				"hadolint", -- dockerfile lint
				"yamllint", -- yaml lint
			},
		})
	end,
}
