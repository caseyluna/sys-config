-- ------------------------------------------------------------------------------
-- aerial.nvim (stevearc/aerial.nvim) — Code outline / symbol navigator
-- ------------------------------------------------------------------------------
-- What it does: Shows a sidebar (or floating window) of the current file's
--   symbol tree — functions, classes, methods, variables — extracted via LSP
--   or treesitter. Supports fuzzy-jumping with Telescope integration.
-- Keymaps:
--   <leader>ra  — toggle aerial sidebar
--   <leader>rA  — open aerial in Telescope (fuzzy symbol search)
-- Notes: Loads lazily on first keymap press. Falls back to treesitter if no
--   LSP is attached. Respects the current colorscheme for highlight groups.
-- Depends on: nvim-web-devicons (icons).
-- ------------------------------------------------------------------------------

return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>ra", "<cmd>AerialToggle!<CR>", desc = "Aerial: toggle outline sidebar" },
		{
			"<leader>rA",
			function()
				require("telescope").extensions.aerial.aerial()
			end,
			desc = "Aerial: Telescope symbol search",
		},
	},
	opts = {
		-- Prefer LSP symbols; fall back to treesitter
		backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },

		layout = {
			max_width = { 40, 0.2 }, -- 40 cols or 20% of window width
			min_width = 20,
			default_direction = "right",
			placement = "window",
		},

		-- Show line guides from symbol to its location in the buffer
		show_guides = true,

		-- Attach to Telescope for fuzzy symbol search
		attach_mode = "window",
	},

	config = function(_, opts)
		require("aerial").setup(opts)
		-- Register Telescope extension
		local ok, telescope = pcall(require, "telescope")
		if ok then
			telescope.load_extension("aerial")
		end
	end,
}
