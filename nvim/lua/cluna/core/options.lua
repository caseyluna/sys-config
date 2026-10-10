-- ------------------------------------------------------------------------------
-- options.lua — Core Neovim settings
-- ------------------------------------------------------------------------------
-- What it does:
--   Sets global editor behavior: line numbers, cursor line, colors, tab/indent,
--   search (ignorecase, smartcase, hlsearch), clipboard, split direction, undo
--   file, completeopt. Netrw list style and disabled built-in plugins are in lazy.lua.
--
-- How to interact:
--   Edit this file to change default UI or editing behavior. Restart Neovim to apply.
--
-- Author: Casey A. Thayer
-- Location: ~/.config/nvim/lua/cluna/core/options.lua
-- ------------------------------------------------------------------------------

local opt = vim.opt
local g = vim.g

-- ------------------------------------------------------------------------------
-- 🗂 UI & Display
-- ------------------------------------------------------------------------------

opt.number = true -- Show absolute line number on cursor line
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Keep sign column visible
opt.wrap = false -- Don't wrap lines
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.background = "dark" -- Set background for dark color schemes
opt.synmaxcol = 240 -- Avoid slow highlighting on long lines

-- Use a cleaner Netrw list style
g.netrw_liststyle = 3

-- ------------------------------------------------------------------------------
-- 🛠 Tabs & Indentation
-- ------------------------------------------------------------------------------

opt.tabstop = 2 -- Number of spaces a <Tab> counts for
opt.shiftwidth = 2 -- Number of spaces to use for autoindent
opt.expandtab = true -- Convert tabs to spaces
opt.autoindent = true -- Copy indent from current line
opt.smartindent = true -- Add smart autoindenting for new lines

-- ------------------------------------------------------------------------------
-- 🔍 Search
-- ------------------------------------------------------------------------------

opt.ignorecase = true -- Ignore case in search by default...
opt.smartcase = true -- ... unless uppercase letters are used
opt.incsearch = true -- Show match while typing
opt.hlsearch = true -- Highlight search matches

-- ------------------------------------------------------------------------------
-- 📋 Clipboard & Backspace
-- ------------------------------------------------------------------------------

opt.clipboard:append("unnamedplus") -- Use system clipboard as default register
opt.backspace = "indent,eol,start" -- Backspace over everything in insert mode

-- ------------------------------------------------------------------------------
-- 🪟 Split Behavior
-- ------------------------------------------------------------------------------

opt.splitright = true -- Vertical splits open to the right
opt.splitbelow = true -- Horizontal splits open below

-- ------------------------------------------------------------------------------
-- 📁 File Handling
-- ------------------------------------------------------------------------------

opt.swapfile = false -- Disable swapfile
opt.backup = false -- Disable backup files
opt.writebackup = false -- Disable backup before overwriting a file
opt.undofile = true -- Enable persistent undo
opt.encoding = "utf-8" -- Set global string encoding
opt.fileencoding = "utf-8" -- File-specific encoding

-- ------------------------------------------------------------------------------
-- 🚀 Performance
-- ------------------------------------------------------------------------------
-- Note: Don't set lazyredraw globally; it breaks Noice and is only for temporary
-- use (e.g. during macro execution). Use :set lazyredraw in a macro if needed.

-- ------------------------------------------------------------------------------
-- 📂 Folding (Treesitter: expr + foldexpr so AST-based folds work)
-- ------------------------------------------------------------------------------

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- current nvim-treesitter API (replaces removed nvim-treesitter.fold module)
opt.foldlevelstart = 99 -- Start with folds open when opening a file
opt.foldenable = true

-- ------------------------------------------------------------------------------
-- 🤖 Completion
-- ------------------------------------------------------------------------------

opt.completeopt = { "menuone", "noselect" } -- Better popup menu experience
