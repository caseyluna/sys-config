# Documentation Index

| Document | Use when you want to… |
|---|---|
| [INSTALL.md](INSTALL.md) | Set up a new machine; see the symlink table; clean-room test. |
| [KEYS.md](KEYS.md) | Find a Neovim key (every plugin's keymaps, by task). |
| [CHEATSHEET.md](CHEATSHEET.md) | Find a shell alias/function or tmux key. |
| [WORKFLOWS.md](WORKFLOWS.md) | Do a task end-to-end: navigate code, review a PR, debug, test, sessions, Claude. |
| [UPDATING.md](UPDATING.md) | Add/remove/update plugins, tools, aliases; which file owns what. |
| [DEBUG.md](DEBUG.md) | Something broke: shell, tmux, Neovim, git, setup. |
| [TESTING.md](TESTING.md) | `scripts/lint.sh` vs `scripts/validate.sh`; CI. |
| [GIT-REBASE.md](GIT-REBASE.md) | Interactive rebase with lazygit or the terminal. |

Quick facts: Neovim leader `<Space>` · tmux prefix `Ctrl-A` · shell reload `sz` · tmux reload `prefix + r` · Neovim plugins `:Lazy`, tools `:Mason`.

## Repo layout

| Path | What it is |
|---|---|
| `setup.sh` | One-shot bootstrap. `do_links()` is the single source of truth for symlinks. |
| `install.sh` | One-line bootstrap (`curl … \| bash`): ensures git, clones the repo, runs `setup.sh`. |
| `Brewfile` | Homebrew packages, grouped by purpose with a comment on each. |
| `zsh/` | `.zprofile` (PATH/env once) · `.zshrc` (interactive) · `aliases.shrc` · `functions.shrc` |
| `fzf/` | `key-bindings.zsh` loader + `*-widget.zsh` custom widgets |
| `tmux/.tmux.conf` | tmux config; plugins auto-install to `~/.tmux/plugins` |
| `nvim/` | `init.lua`, `lua/cluna/core/` (options, keymaps), `lua/cluna/lazy.lua`, `lua/cluna/plugins/` (one file per plugin) |
| `git-configs/` | `.gitconfig`, `.gitignore_global` |
| `starship/`, `ghostty/` | prompt and terminal config |
| `claude/` | Claude Code: `settings.json`, `CLAUDE.md`, `keybindings.json`, `statusline.sh`, `hooks/`, `skills/`, `agents/` |
| `scripts/` | `lint.sh`, `validate.sh`, `tmux-sessionizer`, `code-session.sh` |
| `.claude/settings.json` | Project-scoped Claude permissions for this repo |
