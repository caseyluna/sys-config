-- ------------------------------------------------------------------------------
-- catppuccin.nvim (catppuccin/nvim) — Colorscheme
-- ------------------------------------------------------------------------------
-- What it does: Pastel colorscheme with multiple flavors (mocha, frappe, etc.).
--   Loaded early (priority 1000) so UI plugins pick up highlights.
-- Keymaps: None.
-- Notes: Change flavor to "catppuccin-latte", "catppuccin-frappe", etc. in config.
--   Integrations are listed explicitly: auto_integrations calls vim.pack.get()
--   on nvim 0.12, which creates site/pack/core and makes :checkhealth lazy warn.
--   Adding a plugin catppuccin themes? Add it to `integrations` below.
-- ------------------------------------------------------------------------------

return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				auto_integrations = false,
				integrations = {
					aerial = true,
					blink_cmp = { enabled = true, style = "bordered" },
					dap = true,
					dap_ui = true,
					diffview = true,
					flash = true,
					gitsigns = true,
					harpoon = true,
					indent_blankline = { enabled = true, scope_color = "", colored_indent_levels = false },
					lsp_trouble = true,
					mason = true,
					neotest = true,
					neotree = true,
					notify = true,
					nvim_surround = true,
					octo = true,
					render_markdown = true,
					snacks = true,
					telescope = true,
					which_key = true,
					window_picker = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
