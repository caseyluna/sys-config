-- ------------------------------------------------------------------------------
-- lazygit.nvim (kdheepak/lazygit.nvim) — LazyGit in a floating terminal
-- ------------------------------------------------------------------------------
-- What it does: Opens the lazygit CLI in a floating window. Requires lazygit
--   installed (e.g. brew install lazygit). Warns if lazygit is missing.
-- Keymaps: <leader>lg (repo), <leader>lG (current file), <leader>lC (config).
-- Notes: Uses plenary; window options set in config (blend, scaling).
-- ------------------------------------------------------------------------------

return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim", -- required for plugin functionality
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "Open LazyGit (repo)" },
		{ "<leader>lG", "<cmd>LazyGitCurrentFile<CR>", desc = "Open LazyGit (current file)" },
		{ "<leader>lC", "<cmd>LazyGitConfig<CR>", desc = "Edit LazyGit config" },
	},
	config = function()
		-- Optional: Tweak floating window appearance
		vim.g.lazygit_floating_window_winblend = 10 -- transparency
		vim.g.lazygit_floating_window_scaling_factor = 0.9
		vim.g.lazygit_use_neovim_remote = 1

		-- Warn if LazyGit CLI is not installed
		if vim.fn.executable("lazygit") == 0 then
			vim.notify("⚠️ LazyGit is not installed on your system.", vim.log.levels.WARN)
		end
	end,
}
