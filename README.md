# sys-config

Dotfiles + one-script bootstrap for the same dev environment on **macOS, Fedora and Ubuntu**: **zsh · tmux · Neovim · git · Ghostty · Claude Code**.

```bash
curl -fsSL https://raw.githubusercontent.com/caseyluna/sys-config/main/install.sh | bash   # clone → setup.sh: (Linux: distro pkgs) Homebrew, Brewfile, symlinks, OMZ, TPM, pyenv, fnm, nvim, Claude
exec zsh
task doctor                           # everything green?
```

Headless Linux server: `curl -fsSL …/install.sh | bash -s -- --yes --no-gui`. Already cloned? `bash setup.sh` (or `task setup`).

| I want to… | Go to |
|---|---|
| Install on a new machine / see what gets linked where | [docs/INSTALL.md](docs/INSTALL.md) |
| Look up a Neovim key | [docs/KEYS.md](docs/KEYS.md) |
| Look up a shell alias / tmux key | [docs/CHEATSHEET.md](docs/CHEATSHEET.md) |
| Do a task end-to-end (review a PR, debug, test…) | [docs/WORKFLOWS.md](docs/WORKFLOWS.md) |
| Add or update a plugin / tool / alias | [docs/UPDATING.md](docs/UPDATING.md) |
| Fix something broken | [docs/DEBUG.md](docs/DEBUG.md) |
| All docs | [docs/INDEX.md](docs/INDEX.md) |

## Layout

```
setup.sh        bootstrap, macOS + Linux (idempotent; --links-only / --no-brew / --no-nvim / --yes)
Brewfile        every Homebrew formula/cask (macOS + Linux; casks in `if OS.mac?`)
zsh/            .zprofile (PATH/env, once) · .zshrc (interactive) · aliases.shrc · functions.shrc
fzf/            custom fzf widgets (Ctrl-E, Ctrl-O)
tmux/           .tmux.conf (plugins install themselves into ~/.tmux/plugins)
nvim/           init.lua → lua/cluna/{core,lazy,plugins/<one file per plugin>}
git-configs/    .gitconfig · .gitignore_global
starship/       prompt          ghostty/   terminal
claude/         Claude Code: settings.json · CLAUDE.md · keybindings · statusline · hooks/ · skills/
scripts/        lint.sh (pre-commit) · validate.sh (post-install) · tmux-sessionizer · code-session.sh
                linux/ fedora.sh · ubuntu.sh · lib.sh — system packages Homebrew can't provide
docs/           the guides above
```

## Extending

| Add a… | Edit | Then |
|---|---|---|
| shell alias / function | `zsh/aliases.shrc` / `zsh/functions.shrc` (functions get a `# USAGE:` line) | `sz` |
| Neovim plugin | new `nvim/lua/cluna/plugins/<name>.lua` (copy a banner) + group in `which-key.lua` + row in `docs/KEYS.md` | `:Lazy sync` |
| LSP / formatter / linter | `lspconfig.lua` + `mason.lua` (+ `formatting.lua` / `lint.lua`) | `:MasonToolsInstall` |
| Homebrew package | `Brewfile` (right section, with a comment; macOS-only → `if OS.mac?` + Linux twin in `scripts/linux/`) | `brew bundle --file=Brewfile` |
| Linux system package | both `scripts/linux/fedora.sh` and `ubuntu.sh` | `bash scripts/linux/<distro>.sh` |
| tmux plugin | `set -g @plugin` line in `tmux/.tmux.conf` | `prefix + I` |
| Claude skill | `claude/skills/<name>/SKILL.md` | available in every project |
| symlinked file | `do_links()` in `setup.sh` + table in `docs/INSTALL.md` | `bash setup.sh --links-only` |

Before committing: `bash scripts/lint.sh`. CI runs the same on every push/PR.
