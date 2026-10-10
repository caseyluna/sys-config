-- ------------------------------------------------------------------------------
-- render-markdown.nvim (MeanderingProgrammer/render-markdown.nvim)
-- ------------------------------------------------------------------------------
-- What it does: Renders markdown inline in Neovim buffers — no preview split,
--   no mode switch. Headers get visual hierarchy, bullets use real symbols,
--   code blocks get a background + syntax highlight, tables align, bold/italic
--   render in normal mode.
-- Notes: file_types includes "octo" so PR descriptions and issue bodies in
--   octo.nvim render as formatted markdown automatically.
-- Depends on: nvim-treesitter (markdown parser), nvim-web-devicons (icons).
-- ------------------------------------------------------------------------------

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "octo", "gitcommit", "Avante" },
	opts = {
		-- Enable for markdown files and octo.nvim PR/issue buffers
		file_types = { "markdown", "octo", "gitcommit" },

		-- Render mode: only show formatting in normal mode (not while editing)
		render_modes = { "n", "c" },

		-- Headings: progressively indented with level icons
		heading = {
			enabled = true,
			sign = false, -- don't show sign column icon (clutters octo buffers)
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},

		-- Bullet list symbols (cycle through levels)
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
		},

		-- Code blocks: add background highlight and language badge
		code = {
			enabled = true,
			sign = false,
			style = "full", -- "full" = language label + background on whole block
			border = "thin",
			above = "▄",
			below = "▀",
		},

		-- Horizontal rules rendered as a full-width line
		dash = {
			enabled = true,
			icon = "─",
			width = "full",
		},

		-- Checkboxes in task lists
		checkbox = {
			enabled = true,
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},

		-- Tables: pad columns, add border characters
		pipe_table = {
			enabled = true,
			style = "full",
		},

		-- Inline code: subtle highlight
		inline_highlight = { enabled = true },

		-- Links: show icon before URLs
		link = {
			enabled = true,
			image = "󰥶 ",
			hyperlink = "󰌹 ",
		},
	},
}
