#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# setup.sh — One-shot bootstrap for sys-config dotfiles (macOS, Apple Silicon)
# ------------------------------------------------------------------------------
# What it does (in order; every step is idempotent and safe to re-run):
#   1. preflight   — git/curl/zsh present; Xcode CLT installed (macOS)
#   2. brew        — install Homebrew, then `brew bundle --no-upgrade` (Brewfile)
#   3. links       — symlink dotfiles from $HOME / ~/.config into this repo
#   4. zsh         — Oh My Zsh (keeps our .zshrc), fzf-tab plugin
#   5. tmux        — TPM clone + install all plugins listed in tmux/.tmux.conf
#   6. python      — pyenv: install + set global Python 3.13
#   7. node        — fnm: install + default LTS (needed by Mason / npm tools)
#   8. nvim        — headless lazy.nvim sync + Mason tool install
#   9. claude      — Linear MCP server at user scope
#  10. shell       — chsh to zsh (asks unless --yes)
#
# Usage:
#   bash setup.sh                 # full run
#   bash setup.sh --links-only    # only step 3 (great for HOME=/tmp/x clean-room tests)
#   bash setup.sh --no-brew       # skip Homebrew/Brewfile
#   bash setup.sh --no-nvim       # skip headless Neovim bootstrap
#   bash setup.sh --yes           # don't prompt (chsh)
#   REPO=/path/to/clone bash setup.sh   # if not running from inside the repo
#
# After: exec zsh. Verify with: bash scripts/validate.sh
# Docs: docs/INSTALL.md (install), docs/DEBUG.md (troubleshooting)
# ------------------------------------------------------------------------------

set -euo pipefail

# ------------------------------------------------------------------------------
# Flags
# ------------------------------------------------------------------------------
DO_BREW=1 DO_NVIM=1 LINKS_ONLY=0 ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    --links-only) LINKS_ONLY=1 ;;
    --no-brew)    DO_BREW=0 ;;
    --no-nvim)    DO_NVIM=0 ;;
    --yes|-y)     ASSUME_YES=1 ;;
    -h|--help)    sed -n '2,30p' "$0"; exit 0 ;;
    *) echo "Unknown flag: $arg (see --help)" >&2; exit 2 ;;
  esac
done

# ------------------------------------------------------------------------------
# Repo root: REPO env if set, else the directory containing this script.
# ------------------------------------------------------------------------------
REPO="${REPO:-$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)}"
export REPO

log()  { echo "[setup] $*"; }
err()  { echo "[setup] ERROR: $*" >&2; }
step() { echo; echo "[setup] ===== $* ====="; }
confirm() {
  [[ $ASSUME_YES -eq 1 ]] && return 0
  read -r -p "[setup] $1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# ------------------------------------------------------------------------------
# link_file SRC DST — idempotent symlink with backup of real files.
#   - already correct  → skip
#   - wrong symlink    → replace
#   - real file/dir    → move to DST.bak.<timestamp>, then link
# ------------------------------------------------------------------------------
link_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    log "SKIP   $dst (already linked)"
    return 0
  fi
  if [[ -L "$dst" ]]; then
    log "FIX    replacing symlink $dst"
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    local backup
    backup="${dst}.bak.$(date +%Y%m%d-%H%M%S)"
    log "BACKUP $dst -> $backup"
    mv "$dst" "$backup"
  fi
  ln -s "$src" "$dst"
  log "LINK   $dst -> $src"
}

# ------------------------------------------------------------------------------
# 3. links — the single source of truth for what gets symlinked where.
#    (docs/INSTALL.md mirrors this table; keep them in sync.)
# ------------------------------------------------------------------------------
do_links() {
  step "links"
  # zsh
  link_file "$REPO/zsh/.zshrc"           "$HOME/.zshrc"
  link_file "$REPO/zsh/.zprofile"        "$HOME/.zprofile"
  link_file "$REPO/zsh/aliases.shrc"     "$HOME/.aliases.shrc"
  link_file "$REPO/zsh/functions.shrc"   "$HOME/.functions.shrc"
  # tmux (plugins live in ~/.tmux/plugins — a real dir, never a symlink into the repo)
  link_file "$REPO/tmux/.tmux.conf"      "$HOME/.tmux.conf"
  # git
  link_file "$REPO/git-configs/.gitconfig"        "$HOME/.gitconfig"
  link_file "$REPO/git-configs/.gitignore_global" "$HOME/.gitignore_global"
  # neovim
  link_file "$REPO/nvim"                 "$HOME/.config/nvim"
  # prompt + terminal
  link_file "$REPO/starship/starship.toml" "$HOME/.config/starship.toml"
  link_file "$REPO/ghostty"              "$HOME/.config/ghostty"
  # scripts on PATH
  link_file "$REPO/scripts/tmux-sessionizer" "$HOME/.local/bin/tmux-sessionizer"
  # Claude Code — link individual files/dirs only; ~/.claude itself holds state
  link_file "$REPO/claude/settings.json"   "$HOME/.claude/settings.json"
  link_file "$REPO/claude/CLAUDE.md"       "$HOME/.claude/CLAUDE.md"
  link_file "$REPO/claude/keybindings.json" "$HOME/.claude/keybindings.json"
  link_file "$REPO/claude/statusline.sh"   "$HOME/.claude/statusline.sh"
  link_file "$REPO/claude/hooks"           "$HOME/.claude/hooks"
  link_file "$REPO/claude/skills"          "$HOME/.claude/skills"
  link_file "$REPO/claude/agents"          "$HOME/.claude/agents"

  # Stale links from older versions of this repo
  for stale in "$HOME/.zshprofile" "$HOME/.p10k.zsh" "$HOME/.fzf" "$HOME/.config/kitty"; do
    if [[ -L "$stale" && "$(readlink "$stale")" == "$REPO"* ]]; then
      log "CLEAN  removing stale link $stale"
      rm -f "$stale"
    fi
  done
}

if [[ $LINKS_ONLY -eq 1 ]]; then
  do_links
  log "Links done (--links-only)."
  exit 0
fi

# ------------------------------------------------------------------------------
# 1. preflight
# ------------------------------------------------------------------------------
step "preflight"
for cmd in git curl zsh; do
  command -v "$cmd" &>/dev/null || { err "Missing required command: $cmd"; exit 1; }
done
if [[ "$(uname)" == "Darwin" ]] && ! xcode-select -p &>/dev/null; then
  err "Xcode Command Line Tools are not installed. Run: xcode-select --install  — then re-run setup."
  exit 1
fi
log "git, curl, zsh, Xcode CLT: ok"

# ------------------------------------------------------------------------------
# 2. brew
# ------------------------------------------------------------------------------
if [[ $DO_BREW -eq 1 ]]; then
  step "brew"
  if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    [[ -x "$prefix/bin/brew" ]] && { eval "$("$prefix/bin/brew" shellenv)"; break; }
  done
  # Homebrew >= 6 refuses formulae from third-party taps until they're trusted
  if brew trust --help &>/dev/null; then
    for tap in $(grep -E '^tap "' "$REPO/Brewfile" | cut -d'"' -f2); do
      brew trust "$tap" >/dev/null 2>&1 && log "trusted tap: $tap"
    done
  fi
  log "brew bundle (no upgrades of already-installed packages)..."
  brew bundle --no-upgrade --file="$REPO/Brewfile"
else
  log "skip: brew (--no-brew)"
  command -v brew &>/dev/null && eval "$(brew shellenv)"
fi

# ------------------------------------------------------------------------------
# 3. links
# ------------------------------------------------------------------------------
do_links

# ------------------------------------------------------------------------------
# 4. zsh — Oh My Zsh (KEEP_ZSHRC so it doesn't replace our symlink) + fzf-tab
# ------------------------------------------------------------------------------
step "zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh..."
  KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  log "Oh My Zsh: present"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A ZSH_PLUGINS=(
  [fzf-tab]="https://github.com/Aloxaf/fzf-tab"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
)
for name in "${!ZSH_PLUGINS[@]}"; do
  if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
    log "Installing zsh plugin $name..."
    git clone -q --depth 1 "${ZSH_PLUGINS[$name]}" "$ZSH_CUSTOM/plugins/$name"
  else
    log "zsh plugin $name: present"
  fi
done

# ------------------------------------------------------------------------------
# 5. tmux — TPM + plugins. ~/.tmux must be a real directory (plugins are state,
#    not config). A symlink into the repo would commit plugin clones.
# ------------------------------------------------------------------------------
step "tmux"
if [[ -L "$HOME/.tmux" ]]; then
  err "$HOME/.tmux is a symlink ($(readlink "$HOME/.tmux")). Plugins would be written into that target."
  err "Fix: rm $HOME/.tmux && mkdir -p $HOME/.tmux/plugins && re-run setup. Skipping tmux plugin install."
else
  mkdir -p "$HOME/.tmux/plugins"
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Cloning TPM..."
    git clone -q --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
  log "Installing tmux plugins from .tmux.conf..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null && log "tmux plugins: ok"
fi

# ------------------------------------------------------------------------------
# 6. python — pyenv (installed by Brewfile): ensure 3.13 and make it global
# ------------------------------------------------------------------------------
step "python"
if command -v pyenv &>/dev/null; then
  PY_VER="${PY_VER:-3.13}"
  latest=$(pyenv latest --known "$PY_VER" 2>/dev/null || true)
  if [[ -n "$latest" ]]; then
    pyenv install --skip-existing "$latest"
    pyenv global "$latest"
    log "pyenv global: $latest"
  else
    log "pyenv: could not resolve $PY_VER; skipping"
  fi
else
  log "skip: pyenv not installed"
fi

# ------------------------------------------------------------------------------
# 7. node — fnm LTS (Mason's npm-based servers need node on PATH)
# ------------------------------------------------------------------------------
step "node"
if command -v fnm &>/dev/null; then
  eval "$(fnm env)"
  fnm install --lts >/dev/null 2>&1 || true
  fnm default lts-latest >/dev/null 2>&1 || true
  log "node: $(node --version 2>/dev/null || echo 'not available')"
else
  log "skip: fnm not installed"
fi

# ------------------------------------------------------------------------------
# 8. nvim — bootstrap lazy.nvim plugins and Mason tools headlessly
# ------------------------------------------------------------------------------
if [[ $DO_NVIM -eq 1 ]] && command -v nvim &>/dev/null; then
  step "nvim"
  log "lazy.nvim sync (this clones ~40 plugins on first run)..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || log "lazy sync reported errors — open nvim and run :Lazy"
  log "Mason tool install..."
  nvim --headless "+MasonToolsInstallSync" +qa 2>/dev/null || log "Mason install reported errors — open nvim and run :Mason"
else
  log "skip: nvim bootstrap"
fi

# ------------------------------------------------------------------------------
# 9. claude — register MCP servers at user scope (stored in ~/.claude.json)
# ------------------------------------------------------------------------------
step "claude"
if command -v claude &>/dev/null; then
  if claude mcp get linear &>/dev/null; then
    log "MCP linear: present"
  else
    claude mcp add --scope user --transport http linear https://mcp.linear.app/mcp && log "MCP linear: added"
  fi
else
  log "skip: claude not on PATH (brew bundle installs the claude-code cask)"
fi

# ------------------------------------------------------------------------------
# 10. shell — make zsh the login shell
# ------------------------------------------------------------------------------
step "shell"
ZSH_BIN="$(command -v zsh)"
if [[ "$(basename "${SHELL:-}")" == "zsh" ]]; then
  log "login shell already zsh ($SHELL)"
elif [[ "${SHELL:-}" != "$ZSH_BIN" ]]; then
  if grep -q "^$ZSH_BIN$" /etc/shells || [[ "$ZSH_BIN" == /bin/zsh ]]; then
    if confirm "Change login shell to $ZSH_BIN?"; then
      chsh -s "$ZSH_BIN" && log "login shell: $ZSH_BIN"
    fi
  else
    log "$ZSH_BIN not in /etc/shells; add it (sudo) then: chsh -s $ZSH_BIN"
  fi
fi

echo
log "Setup complete. Next: exec zsh   then   bash $REPO/scripts/validate.sh"
