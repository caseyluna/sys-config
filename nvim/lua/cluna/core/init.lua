-- ------------------------------------------------------------------------------
-- core/init.lua — Core Neovim config loader
-- ------------------------------------------------------------------------------
-- Loads options.lua (editor settings) and keymaps.lua (non-plugin keymaps).
-- Plugin keymaps live in each plugin file; the full list is in docs/KEYS.md.
-- ------------------------------------------------------------------------------

require("cluna.core.options")
require("cluna.core.keymaps")
