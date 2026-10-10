# Debug & troubleshooting

First: `bash scripts/validate.sh`. It names the exact link or tool that's wrong.

## Shell

| Symptom | Check / fix |
|---|---|
| `command not found` for brew tools | `.zprofile` not loaded: `ls -la ~/.zprofile` must point into the repo; `echo $SHELL` should be zsh (`chsh -s $(command -v zsh)`) |
| PATH has duplicates | `print -l $path \| sort \| uniq -d`. `.zprofile` declares `typeset -U path`; something else is exporting PATH — `rg 'export PATH' ~/.zshrc ~/.zprofile` |
| Ctrl-R isn't atuin | `bindkey \| grep '"\^R"'` → must be `atuin-search`. `.zshrc` sources `fzf --zsh` *before* `atuin init`; keep that order |
| Ctrl-E / Ctrl-O do nothing | `command -v fd fzf bat` — all three must exist (Brewfile) |
| Starship missing | `command -v starship`; `brew install starship`; `ls -la ~/.config/starship.toml` |
| Slow startup | `time zsh -i -c exit` (target < 300 ms). `zsh -xv -i -c exit 2>&1 \| head -200` to see what's slow |
| `cat`/`git diff` crash with `dyld: Library not loaded` | A Homebrew lib was upgraded under a dependent: `brew upgrade libgit2 bat git-delta` (or whichever `otool -L $(which bat)` names) |

## tmux

| Symptom | Check / fix |
|---|---|
| Plugins missing (no status bar theme, no `prefix + Ctrl-s`) | `ls ~/.tmux/plugins` — must contain `tpm`. `.tmux.conf` auto-clones it on first start; otherwise `bash setup.sh --no-brew`. Then `prefix + I` |
| `~/.tmux` is a symlink | Plugins would be written into that target. `rm ~/.tmux && mkdir -p ~/.tmux/plugins && bash setup.sh --no-brew --no-nvim` |
| Colors wrong / no undercurl in nvim | `tmux info \| grep -E 'RGB\|Tc\|usstyle'` should show RGB+usstyle (set via `terminal-features`); outside tmux `echo $TERM` should be `xterm-ghostty` |
| `prefix + f` / `prefix + g` do nothing | They use `display-popup` (tmux ≥ 3.2): `tmux -V`. `tmux-sessionizer` must be on PATH (`~/.local/bin`) |
| Ctrl-h/j/k/l don't cross panes | vim-tmux-navigator must be installed on both sides: `prefix + I`, and `:Lazy` shows `nvim-tmux-navigation` |
| Wrong shell in new panes | `default-shell` is your login shell (macOS `dscl`, Linux `getent passwd`); check `echo $SHELL` outside tmux |
| Linux: `y` in copy mode doesn't reach the clipboard | tmux-yank needs `wl-copy` (Wayland) or `xclip` (X11): `command -v wl-copy xclip`; over SSH neither works — use `pbcopy` (OSC 52) |

## Neovim

| Symptom | Check / fix |
|---|---|
| Error popup at startup | `nvim --headless +qa` from a terminal shows the Lua traceback; the plugin name is in `Failed to run config for <plugin>` |
| No completion / LSP | `:LspInfo` (expect e.g. `pyright`, `ruff` on `.py`). `:Mason` — is the server installed? `<leader>rs` restarts |
| Linter not showing | `:lua print(vim.inspect(require("lint").linters_by_ft[vim.bo.filetype]))`; the binary must be in Mason or on PATH (`mypy`, `shellcheck`, `sqlfluff`, `markdownlint`, `hadolint`, `yamllint`) |
| Formatter not running | `:ConformInfo` names the formatter and whether it's found. Errors are shown (not silent) |
| `<Tab>` and `<C-i>` act the same in nvim | Needs Ghostty + tmux `extended-keys` (CSI u): `tmux show -s extended-keys` → `on`; then `tmux kill-server` and restart |
| Copilot not suggesting | `:Copilot status`; needs Node ≥ 22 (`fnm default lts-latest`) and `:Copilot auth` |
| Treesitter highlight missing | `:TSInstall <lang>`; `:checkhealth nvim-treesitter` |
| A key does nothing | `:map <lhs>` or `<leader>fk` (Telescope keymaps). Lazy-loaded plugins map keys as stubs — if the stub is missing the plugin file isn't being imported |
| Health | `:checkhealth lazy vim.lsp mason vim.provider`. Expected warnings only: luarocks/php/java/julia (unused) |
| Roll back a plugin update | `:Lazy restore` (uses `nvim/lazy-lock.json`) or `git checkout -- nvim/lazy-lock.json` then `:Lazy restore` |

## Git

| Symptom | Fix |
|---|---|
| `delta` not paging | `git config --global core.pager` → `delta`; `delta --version` runs? (see dyld note above) |
| LFS errors | `git-lfs` is in the Brewfile; `git lfs install` once |
| `nvim -d` not opening for difftool | `git config --global difftool.nvimdiff.path` → `nvim`; `which nvim` |

## setup.sh

| Symptom | Fix |
|---|---|
| "Xcode Command Line Tools are not installed" | `xcode-select --install`, re-run |
| Linux: "Run as your user, not root" | Homebrew refuses root. Create/use a normal user with sudo and run `bash setup.sh` as it |
| Linux: "No package script for …" | Distro isn't Fedora- or Debian-like. Install the packages listed in `scripts/linux/ubuntu.sh` with your package manager, then `bash setup.sh --no-system` |
| Linux: `pyenv install` → `_ssl` / `_ctypes` missing | Build headers missing or Linuxbrew's pkg-config leaked in. Re-run `bash scripts/linux/<distro>.sh`, then build without brew on PATH: `PATH=$(print -rl $path \| grep -v linuxbrew \| paste -sd:) pyenv install 3.13` |
| Linux: `docker: permission denied … docker.sock` | You were added to group `docker` — log out and back in (or `newgrp docker`) |
| Linux: `brew bundle` slow / compiling | No bottle for your arch (ARM64 Linux) — let it build, or drop the formula behind `if OS.mac?` |
| `brew bundle` fails on a formula | The formula was deprecated/disabled upstream — `brew info <name>`, then edit the Brewfile and re-run (`/brew-audit`) |
| A link was skipped as "already linked" but points to an old clone path | `bash setup.sh --links-only` replaces wrong symlinks; real files are backed up as `<file>.bak.<ts>` |
| Oh My Zsh replaced `.zshrc` | It runs with `KEEP_ZSHRC=yes`; if it still happened, `bash setup.sh --links-only` |
