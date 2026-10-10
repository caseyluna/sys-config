# Install

**Goal:** clone → `bash setup.sh` → working shell, tmux, Neovim, git, Ghostty and Claude Code.

## Prerequisites

- macOS (Apple Silicon). Xcode Command Line Tools: `xcode-select --install` (setup checks and refuses to continue without them — treesitter/fzf-native need a C compiler).
- `git`, `curl`, `zsh` (all ship with macOS).

## Steps

```bash
git clone git@github.com:caseyluna/sys-config.git ~/sys-config   # any path works
cd ~/sys-config
bash setup.sh
exec zsh
bash scripts/validate.sh
```

`setup.sh` runs these steps in order; every step is idempotent, so re-running is safe:

| # | Step | What happens |
|---|---|---|
| 1 | preflight | git/curl/zsh present, Xcode CLT installed |
| 2 | brew | install Homebrew if missing; `brew bundle --no-upgrade --file=Brewfile` |
| 3 | links | symlinks below; real files are moved to `<file>.bak.<timestamp>` first |
| 4 | zsh | Oh My Zsh (`KEEP_ZSHRC=yes`), custom plugins fzf-tab / autosuggestions / fast-syntax-highlighting |
| 5 | tmux | clone TPM into `~/.tmux/plugins`, install every plugin in `.tmux.conf` |
| 6 | python | pyenv: install latest 3.13 and set it global |
| 7 | node | fnm: install LTS and set default (Mason's npm servers need it) |
| 8 | nvim | headless `Lazy! sync` + `MasonToolsInstallSync` — plugins, LSPs, formatters ready before first launch |
| 9 | claude | register the Linear MCP server at user scope |
| 10 | shell | `chsh -s $(command -v zsh)` (asks; `--yes` skips the prompt) |

Flags: `--links-only` (step 3 only), `--no-brew`, `--no-nvim`, `--yes`. `REPO=/path bash setup.sh` if running from outside the clone.

Sign-ins that can't be scripted: `gh auth login`, `claude` (first run), `:Copilot auth` in Neovim, `atuin login` (optional sync), `gcloud auth login`.

## What gets symlinked

Source of truth: `do_links()` in `setup.sh`. Keep this table identical.

| Link | → Repo file |
|---|---|
| `~/.zshrc` | `zsh/.zshrc` |
| `~/.zprofile` | `zsh/.zprofile` |
| `~/.aliases.shrc` | `zsh/aliases.shrc` |
| `~/.functions.shrc` | `zsh/functions.shrc` |
| `~/.tmux.conf` | `tmux/.tmux.conf` |
| `~/.gitconfig` | `git-configs/.gitconfig` |
| `~/.gitignore_global` | `git-configs/.gitignore_global` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/starship.toml` | `starship/starship.toml` |
| `~/.config/ghostty` | `ghostty/` |
| `~/.local/bin/tmux-sessionizer` | `scripts/tmux-sessionizer` |
| `~/.claude/settings.json` | `claude/settings.json` |
| `~/.claude/CLAUDE.md` | `claude/CLAUDE.md` |
| `~/.claude/keybindings.json` | `claude/keybindings.json` |
| `~/.claude/statusline.sh` | `claude/statusline.sh` |
| `~/.claude/hooks` | `claude/hooks/` |
| `~/.claude/skills` | `claude/skills/` |
| `~/.claude/agents` | `claude/agents/` |

Deliberately **not** linked: `~/.tmux` (plugin state), `~/.claude` as a whole (sessions, history, auth), `~/.claude.json`, `~/.fzf` (fzf's own `fzf --zsh` is sourced instead). Stale links from older versions (`~/.zshprofile`, `~/.p10k.zsh`, `~/.fzf`, `~/.config/kitty`) are removed automatically.

## Verify

`bash scripts/validate.sh` checks every link above, required tools, that `bat`/`delta` run (dyld sanity), git config, tmux plugins, and runs a headless Neovim checkhealth. Manual spot checks:

```bash
print -l $path | sort | uniq -d        # should print nothing (no PATH dupes)
bindkey | grep '"\^R"'                  # atuin-search
tmux new -d -s t && tmux show -g history-limit && tmux kill-session -t t   # 50000
nvim --headless "+checkhealth vim.lsp" "+w! /tmp/h.txt" +qa && grep -c ERROR /tmp/h.txt   # 0
```

## Clean-room test

Without touching your real home:

```bash
HOME=/tmp/sc-home bash setup.sh --links-only
HOME=/tmp/sc-home bash scripts/validate.sh
```

For a full run, use a second macOS user account (System Settings → Users), clone there, and run `bash setup.sh --yes`.
