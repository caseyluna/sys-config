# Updating & extending

## Which file owns what

| Change | File | Apply |
|---|---|---|
| Shell alias | `zsh/aliases.shrc` | `sz` |
| Shell function (anything with args/logic) | `zsh/functions.shrc` — add a `# USAGE:` line | `sz` |
| PATH / env var | `zsh/.zprofile` (`path=(…)` block) — never in `.zshrc` | new login shell |
| Interactive shell behavior (plugins, prompt, tool hooks) | `zsh/.zshrc` | `sz` |
| fzf widget | `fzf/<name>-widget.zsh` (auto-sourced) | `sz` |
| Homebrew package | `Brewfile` — right section, one comment per line | `brew bundle --file=Brewfile` |
| tmux | `tmux/.tmux.conf` | `prefix + r`; plugins `prefix + I` |
| Neovim option | `nvim/lua/cluna/core/options.lua` | restart |
| Neovim non-plugin keymap | `nvim/lua/cluna/core/keymaps.lua` | restart |
| Neovim plugin | `nvim/lua/cluna/plugins/<plugin>.lua` | `:Lazy sync` |
| LSP server | `lspconfig.lua` (`servers` table) **and** `mason.lua` (`ensure_installed`) | `:MasonToolsInstall`, restart |
| Formatter | `formatting.lua` (`formatters_by_ft`) + `mason.lua` tools | `:ConformInfo` |
| Linter | `lint.lua` (`linters_by_ft`) + `mason.lua` tools | reopen file |
| Debug adapter | `dap.lua` + `mason.lua` | restart |
| Test adapter | `neotest.lua` | restart |
| Git | `git-configs/.gitconfig` | immediate |
| Prompt | `starship/starship.toml` | immediate |
| Terminal | `ghostty/config` | Ghostty reload (`⌘⇧,`) |
| Claude Code settings / hooks / statusline | `claude/settings.json`, `claude/hooks/*.sh`, `claude/statusline.sh` | next `claude` start |
| Claude global instructions | `claude/CLAUDE.md` | next session |
| Claude skill | `claude/skills/<name>/SKILL.md` | immediate |
| Something new to symlink | `do_links()` in `setup.sh` + table in `docs/INSTALL.md` | `bash setup.sh --links-only` |

## Adding a Neovim plugin

1. Create `nvim/lua/cluna/plugins/<name>.lua`:
   ```lua
   -- ------------------------------------------------------------------------------
   -- plugin-name (owner/repo) — one-line purpose
   -- ------------------------------------------------------------------------------
   -- What it does: …
   -- Keymaps: <leader>xy …
   -- Notes: …
   -- ------------------------------------------------------------------------------
   return {
     "owner/repo",
     keys = { { "<leader>xy", "<cmd>Thing<CR>", desc = "Do the thing" } }, -- lazy-load on key
     opts = {},
   }
   ```
   Prefer `keys` / `cmd` / `ft` / `event` over `lazy = false`.
2. New `<leader>` prefix? Add `{ "<leader>x", group = "…" }` to `which-key.lua`. Check for collisions first: `rg -n '"<leader>xy"' nvim/lua docs/KEYS.md`.
3. Add the keys to `docs/KEYS.md`.
4. `:Lazy sync`, then commit `nvim/lazy-lock.json` with the change.

The `/nvim-plugin` Claude skill does all of this.

## Removing a plugin

Delete the file, remove its which-key group and KEYS.md rows, `:Lazy sync` (cleans the install + lock).

## Updating

| What | How |
|---|---|
| Neovim plugins | `:Lazy update` → test → commit `lazy-lock.json`. Rollback: `:Lazy restore` or `git checkout -- nvim/lazy-lock.json` |
| LSPs / formatters / linters | `:MasonUpdate` (`:Mason` for the UI) |
| Homebrew | `brewup` (update, upgrade, cleanup, doctor) · `brewdiff` shows installed-but-undeclared |
| tmux plugins | `prefix + U` |
| Node | `fnm install --lts && fnm default lts-latest` |
| Python | `pyenv install 3.x && pyenv global 3.x` |
| Claude Code | Homebrew cask: `brew upgrade --cask claude-code` |

Audit the Brewfile periodically: `/brew-audit` skill.

## Verifying

- Before commit: `bash scripts/lint.sh` (CI runs the same).
- After pull / setup: `bash scripts/validate.sh`.
- Everything at once from Claude: `/dotfiles-check`.

## Commit conventions

`type(scope): summary` — e.g. `feat(nvim): add grug-far`, `fix(zsh): guard starship init`, `chore(brew): drop postgresql@14`, `docs: refresh KEYS`.
