-- ------------------------------------------------------------------------------
-- nvim-treesitter — Parsers for highlighting, indent, folds, incremental select
-- ------------------------------------------------------------------------------
-- Keymaps: <C-Space> expand selection · <BS> shrink
-- Notes: Pinned to the `master` branch (the `main` rewrite has a different
--   API). Folding uses vim.treesitter.foldexpr (core/options.lua).
--   nvim-ts-autotag closes/renames HTML tags.
-- ------------------------------------------------------------------------------

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { { "windwp/nvim-ts-autotag", opts = {} } },
	config = function()
		require("nvim-treesitter.configs").setup({
			modules = {},
			auto_install = true,
			sync_install = false,
			ignore_install = {},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					node_decremental = "<BS>",
					scope_incremental = false,
				},
			},
			ensure_installed = {
				"bash",
				"css",
				"diff",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"hcl",
				"html",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"sql",
				"terraform",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
		})
	end,
}
