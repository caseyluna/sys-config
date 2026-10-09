---
name: nvim-plugin
description: Add a Neovim plugin to the sys-config repo following its one-file-per-plugin convention (banner comment, lazy spec, which-key group, docs/KEYS.md entry).
---

# nvim-plugin

Arguments: the plugin repo (`owner/name`) and what it should do / which keys to use.

1. Check it isn't already covered: `ls nvim/lua/cluna/plugins/` and `rg -n "<lhs>" nvim/lua docs/KEYS.md` for every proposed keymap — never shadow an existing key.
2. Create `nvim/lua/cluna/plugins/<name>.lua` with this banner, then the lazy.nvim spec:
   ```lua
   -- ------------------------------------------------------------------------------
   -- <plugin> (<owner/name>) — <one-line purpose>
   -- ------------------------------------------------------------------------------
   -- What it does: …
   -- Keymaps: …
   -- Notes: …
   -- ------------------------------------------------------------------------------
   return { "<owner/name>", keys = { … }, opts = { … } }
   ```
   Lazy-load via `keys`/`cmd`/`ft`/`event` — never `lazy = false` unless it's UI needed at startup.
3. If it introduces a new `<leader>x` prefix, add `{ "<leader>x", group = "…" }` to `nvim/lua/cluna/plugins/which-key.lua`.
4. Add the keymaps to `docs/KEYS.md` under the right section.
5. If it needs an external binary, add it to Mason (`nvim/lua/cluna/plugins/mason.lua`) or the `Brewfile`.
6. Verify: `stylua nvim/lua`, then `nvim --headless "+Lazy! sync" +qa` and `bash scripts/lint.sh`.
