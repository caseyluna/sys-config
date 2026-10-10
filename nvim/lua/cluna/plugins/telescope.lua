-- ------------------------------------------------------------------------------
-- telescope.nvim (nvim-telescope/telescope.nvim) — Fuzzy finder
-- ------------------------------------------------------------------------------
-- What it does: Find files / recent / grep / word / todos / projects, and
--   provides vim.ui.select menus (ui-select) for code actions etc.
-- Keymaps (under <leader>f):
--   ff files   fr recent   fs grep   fc word under cursor   ft todos
--   fb buffers fh help     fk keymaps   fp projects   fg git status
-- Notes: fzf-native is compiled on install (needs make + a C compiler).
--   Directory editing is oil (<leader>o); the file tree is neo-tree (<leader>ee).
-- ------------------------------------------------------------------------------

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-project.nvim",
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
		{ "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
		{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find todos" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
		{ "<leader>fg", "<cmd>Telescope git_status<CR>", desc = "Git status files" },
		{ "<leader>fp", "<cmd>Telescope project<CR>", desc = "Projects" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/", "__pycache__/" },
			},
			pickers = {
				find_files = { hidden = true },
			},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown({}) },
				project = { base_dirs = { "~/projects", "~/sys-config", "~/.config" }, hidden_files = true },
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("project")
	end,
}
