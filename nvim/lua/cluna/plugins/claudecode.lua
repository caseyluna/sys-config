-- ------------------------------------------------------------------------------
-- claudecode.nvim (coder/claudecode.nvim) — Claude Code IDE in Neovim
-- ------------------------------------------------------------------------------
-- What it does: Neovim integration for Claude Code (Anthropic's AI coding assistant).
--   Uses the same WebSocket MCP protocol as the official VS Code extension.
--   Requires: Claude Code CLI (claude doctor), folke/snacks.nvim (dependency).
-- Keymaps: <leader>c (group), <leader>cc toggle, <leader>cf focus. Alt+w = switch
--   editor ↔ Claude from anywhere (normal or terminal input). <leader>cs, cA, cd.
-- ------------------------------------------------------------------------------

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		require("claudecode").setup()
		local switch_win = { desc = "Switch to other window (editor ↔ Claude)" }
		-- Normal mode: Alt+w → previous window (editor ↔ Claude)
		vim.keymap.set("n", "<A-w>", "<C-w>p", switch_win)
		-- Terminal mode (e.g. typing in Claude): Alt+w → exit to normal, then previous window
		vim.keymap.set("t", "<A-w>", "<C-\\><C-n><C-w>p", switch_win)
	end,
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude" },
		{ "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
		{ "<leader>cw", "<C-w>p", desc = "Switch to other window (same as Alt+w)" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<CR>", desc = "Resume Claude" },
		{ "<leader>cC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue Claude" },
		{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", desc = "Select Claude model" },
		{ "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>cs",
			"<cmd>ClaudeCodeTreeAdd<CR>",
			desc = "Add file (neo-tree/oil)",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		{ "<leader>cA", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
		{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
	},
}
