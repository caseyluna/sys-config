-- ------------------------------------------------------------------------------
-- keymaps.lua — Core key bindings (non-plugin)
-- ------------------------------------------------------------------------------
-- What it does:
--   Leader = <Space>. Defines: jk (exit insert), <leader>nh (nohl),
--   <leader>+/- (inc/dec number), <leader>s* (splits incl. sm maximize),
--   <leader>t* (tabs). Pane navigation <C-h/j/k/l> lives in
--   plugins/vim-tmux-navigator.lua so it works across tmux and Neovim.
--
-- How to interact:
--   Add keymaps with vim.keymap.set(mode, lhs, rhs, { desc = "..." }).
--   Plugin keymaps go in the plugin's own file. Full list: docs/KEYS.md.
--
-- Location: ~/.config/nvim/lua/cluna/core/keymaps.lua
-- ------------------------------------------------------------------------------

vim.g.mapleader = " "
local keymap = vim.keymap

-- ------------------------------------------------------------------------------
-- ⌨️ General
-- ------------------------------------------------------------------------------
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

-- ------------------------------------------------------------------------------
-- 🔢 Numbers
-- ------------------------------------------------------------------------------
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- ------------------------------------------------------------------------------
-- 🔲 Splits  (<leader>s = splits; project search lives under <leader>S)
-- ------------------------------------------------------------------------------
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Maximize / restore the current split (replaces vim-maximizer)
keymap.set("n", "<leader>sm", function()
	if vim.t.maximized_layout then
		vim.cmd(vim.t.maximized_layout)
		vim.t.maximized_layout = nil
	else
		vim.t.maximized_layout = vim.fn.winrestcmd()
		vim.cmd("wincmd _ | wincmd |")
	end
end, { desc = "Maximize / restore split" })

-- ------------------------------------------------------------------------------
-- 🗂 Tabs
-- ------------------------------------------------------------------------------
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Current buffer in new tab" })

-- ------------------------------------------------------------------------------
-- 📋 Yank feedback (native; replaces yanky's highlight)
-- ------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("cluna_yank_highlight", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})
