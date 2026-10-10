-- ------------------------------------------------------------------------------
-- nvim-spectre (nvim-pack/nvim-spectre) — Project-wide find and replace
-- ------------------------------------------------------------------------------
-- What it does: Opens a search/replace panel that shows all matches across the
--   project (powered by ripgrep) with a live preview. Replacements can be
--   applied per-match, per-file, or all at once. Supports regex and plain text,
--   case sensitivity, and file-type filters.
-- Keymaps:
--   <leader>SS  — open Spectre (project-wide search)
--   <leader>Sw  — search current word across project
--   <leader>Sf  — search in current file only
-- Notes: Requires ripgrep (rg) and sed/oxi-replace for substitutions.
--   Both are available via Homebrew and declared in Brewfile.
-- ------------------------------------------------------------------------------

return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Spectre",
	keys = {
		{
			"<leader>SS",
			function()
				require("spectre").toggle()
			end,
			desc = "Spectre: project-wide find/replace",
		},
		{
			"<leader>Sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Spectre: search current word",
			mode = { "n" },
		},
		{
			"<leader>Sw",
			function()
				require("spectre").open_visual()
			end,
			desc = "Spectre: search selection",
			mode = { "v" },
		},
		{
			"<leader>Sf",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Spectre: search in file",
		},
	},
	opts = {
		open_cmd = "noswapfile vnew",
		live_update = false, -- manual refresh to avoid hammering rg on large repos
		highlight = {
			ui = "String",
			search = "DiffChange",
			replace = "DiffDelete",
		},
	},
}
