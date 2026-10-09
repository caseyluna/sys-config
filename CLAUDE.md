# sys-config — repo conventions for Claude

Dotfiles that bootstrap a Mac: `setup.sh` (links + installs), `Brewfile`, `zsh/`, `tmux/`, `nvim/`, `claude/`, `docs/`.

- **Layout rule:** one directory per tool; `setup.sh` `do_links()` is the single source of truth for what gets symlinked where. Update it and `docs/INSTALL.md` together.
- **Neovim:** one plugin per file in `nvim/lua/cluna/plugins/`, each starting with the banner comment (what / keymaps / notes). Lazy-load via `keys`/`cmd`/`ft`. Servers in `lspconfig.lua` must match `mason.lua`. New `<leader>` prefixes get a group in `which-key.lua` and a row in `docs/KEYS.md`.
- **Shell:** PATH/env only in `zsh/.zprofile`; interactive setup in `.zshrc`; aliases in `aliases.shrc`; anything with logic is a function in `functions.shrc` with a `# USAGE:` line.
- **tmux plugins** live in `~/.tmux/plugins` (state) — never in the repo.
- **Claude config** is `claude/` (linked file-by-file into `~/.claude`); never commit `.claude/settings.local.json` or `~/.claude.json`.
- **Before committing:** `bash scripts/lint.sh` must pass; check the branch (`git branch --show-current`).
- **Docs:** `docs/KEYS.md` = Neovim keys, `docs/CHEATSHEET.md` = shell + tmux, `docs/INSTALL.md` = bootstrap, `docs/DEBUG.md` = troubleshooting.
