# Install

**Goal:** clone → `bash setup.sh` → working shell, tmux, Neovim, git, Ghostty and Claude Code — the same on macOS and Linux.

## Prerequisites

| OS | Before `setup.sh` |
|---|---|
| macOS (Apple Silicon / Intel) | Xcode Command Line Tools: `xcode-select --install` (setup refuses to continue without them — treesitter/fzf-native need a C compiler). `git`, `curl`, `zsh` ship with macOS. |
| Fedora (or RHEL/Rocky/Alma) | `sudo dnf install -y git` — setup installs everything else. |
| Ubuntu (or Debian/Pop!_OS/Mint) | `sudo apt install -y git curl` — setup installs everything else. |
| Other Linux | Install a C compiler + make, `git curl zsh file procps`, Python build headers and `xclip`/`wl-clipboard` yourself (`scripts/linux/ubuntu.sh` is the list), then run setup. |

On Linux, run as your normal user (not root) with `sudo` rights: Homebrew refuses root and setup calls `sudo` for system packages.

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
| 0 | system | **Linux only:** `scripts/linux/fedora.sh` or `ubuntu.sh` (picked from `/etc/os-release`) — see [Linux](#linux) |
| 1 | preflight | git/curl/zsh present, Xcode CLT installed (macOS) |
| 2 | brew | install Homebrew if missing (Linux: `/home/linuxbrew/.linuxbrew`); `brew bundle --no-upgrade --file=Brewfile` |
| 3 | links | symlinks below; real files are moved to `<file>.bak.<timestamp>` first |
| 4 | zsh | Oh My Zsh (`KEEP_ZSHRC=yes`), custom plugins fzf-tab / autosuggestions / fast-syntax-highlighting |
| 5 | tmux | clone TPM into `~/.tmux/plugins`, install every plugin in `.tmux.conf` |
| 6 | python | pyenv: install latest 3.13 and set it global |
| 7 | node | fnm: install LTS and set default (Mason's npm servers need it) |
| 8 | nvim | headless `Lazy! sync` + `MasonToolsInstallSync` — plugins, LSPs, formatters ready before first launch |
| 9 | claude | Linux: install Claude Code (native installer → `~/.local/bin/claude`); register the Linear MCP server at user scope |
| 10 | shell | `chsh` to the OS zsh (`/bin/zsh` or `/usr/bin/zsh`; asks, `--yes` skips the prompt) |

Flags: `--links-only` (step 3 only), `--no-brew`, `--no-nvim`, `--yes`; Linux: `--no-system` (skip step 0), `--gui` / `--no-gui` (force/skip Ghostty, fonts, flatpaks — default: on when a desktop session is detected). `REPO=/path bash setup.sh` if running from outside the clone.

Sign-ins that can't be scripted: `gh auth login`, `claude` (first run), `:Copilot auth` in Neovim, `atuin login` (optional sync), `gcloud auth login`.

## Linux

Same idea as macOS: the **Brewfile is the toolchain on every OS** (Homebrew on Linux), so `nvim`, `tmux`, `fzf`, `rg`, `bat`, `fd`, `lazygit`, `uv`, `terraform`, … are the same versions with the same names (no `batcat` / `fdfind`), and every config file is shared. Only what Homebrew can't or shouldn't provide on Linux comes from the distro script:

| Need | macOS (Brewfile) | Linux (`scripts/linux/<distro>.sh`) |
|---|---|---|
| C toolchain, Python build headers | Xcode CLT | `@development-tools` + `*-devel` / `build-essential` + `lib*-dev` |
| Login shell | `/bin/zsh` | distro `zsh` (`/usr/bin/zsh`; Fedora also `util-linux-user` for `chsh`) |
| Clipboard (tmux-yank, nvim `+`, `pbcopy`) | built in | `wl-clipboard` + `xclip`; `pbcopy`/`pbpaste`/`open` shims in `functions.shrc` (OSC 52 over SSH) |
| Notifications (Claude hook) | `terminal-notifier` | `notify-send` (libnotify) |
| Docker | `docker-desktop` cask | `moby-engine` / `docker.io` + compose + buildx, service enabled, you in group `docker` (re-login) |
| gcloud / bq | `gcloud-cli` cask | `google-cloud-cli` from Google's dnf/apt repo |
| Ghostty | cask | Fedora: COPR `scottames/ghostty` · Ubuntu: `snap install ghostty --classic` (desktop only) |
| Nerd Fonts | `font-jetbrains-mono-nerd-font` cask | JetBrainsMono → `~/.local/share/fonts/NerdFonts` (desktop only) |
| DBeaver / Zoom | casks | Flathub, per user (desktop only) · Notion, Tuple, DockFix: no Linux build |
| Claude Code | `claude-code` cask | native installer → `~/.local/bin/claude` (setup step 9) |

macOS-only entries sit in `if OS.mac?` blocks in the `Brewfile`. Adding a cask? Put its Linux twin in both distro scripts (Flathub id → `FLATPAKS` in `scripts/linux/lib.sh`).

Notes: x86_64 Linux gets Homebrew bottles for everything; on ARM64 Linux a few formulae may build from source (slow first run). Fedora Atomic (Silverblue) isn't supported (rpm-ostree). On GNOME, `super+arrow` (Ghostty split navigation) is taken by window tiling — rebind in GNOME Settings or `ghostty/config`.

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
| `~/Taskfile.yml` | `Taskfile.yml` (`task -g <name>` from anywhere) |
| `~/.config/ghostty` | `ghostty/` |
| `~/.local/bin/tmux-sessionizer` | `scripts/tmux-sessionizer` |
| `~/.claude/settings.json` | `claude/settings.json` |
| `~/.claude/CLAUDE.md` | `claude/CLAUDE.md` |
| `~/.claude/keybindings.json` | `claude/keybindings.json` |
| `~/.claude/statusline.sh` | `claude/statusline.sh` |
| `~/.claude/hooks` | `claude/hooks/` |
| `~/.claude/skills` | `claude/skills/` |
| `~/.claude/agents` | `claude/agents/` |

Deliberately **not** linked: `~/.tmux` (plugin state), `~/.claude` as a whole (sessions, history, auth), `~/.claude.json`, `~/.fzf` (fzf's own `fzf --zsh` is sourced instead). Stale links from older versions (`~/.zshprofile`, `~/.p10k.zsh`, `~/.fzf`) are removed automatically.

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

Linux full run in a throwaway container (Homebrew needs a non-root sudo user):

```bash
docker run --rm -it -v "$PWD":/src:ro fedora:latest bash   # or ubuntu:24.04
# inside: dnf install -y git sudo  (apt-get update && apt-get install -y git sudo)
useradd -m dev && echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev
cp -r /src /home/dev/sys-config && chown -R dev: /home/dev/sys-config
su - dev -c 'cd ~/sys-config && bash setup.sh --yes --no-gui'
```

CI does the same when a PR touches install inputs (Brewfile, `scripts/linux/`, `setup.sh` install steps) and weekly; other bootstrap-file PRs get a quick links + zsh/tmux check (`.github/workflows/linux-bootstrap.yml`, see [TESTING.md](TESTING.md)).
