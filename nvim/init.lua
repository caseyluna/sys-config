-- ------------------------------------------------------------------------------
-- init.lua — Neovim entry point
-- ------------------------------------------------------------------------------
-- What it does:
--   Loads core (options + keymaps) then lazy.nvim, which loads every spec in
--   lua/cluna/plugins/. Leader is <Space>.
--
-- How to interact:
--   Config lives in the sys-config repo under nvim/ (~/.config/nvim is a symlink).
--   Add a plugin: create lua/cluna/plugins/<name>.lua returning a lazy spec.
--   Keymaps: lua/cluna/core/keymaps.lua + each plugin file; full list: docs/KEYS.md.
--
-- Location: ~/.config/nvim/init.lua
-- ------------------------------------------------------------------------------

-- Providers we never use — silences :checkhealth warnings and skips their probes
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

require("cluna.core") -- options + keymaps
require("cluna.lazy") -- plugin manager + all plugin specs
