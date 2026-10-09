#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# validate.sh — Post-install check: is this machine wired up to the repo?
# ------------------------------------------------------------------------------
# Verifies every symlink from docs/INSTALL.md, required tools, that Homebrew
# binaries actually run (dyld sanity), git identity, tmux plugins, and a
# headless Neovim checkhealth. Run after setup.sh or after pulling changes.
#
# Usage: bash scripts/validate.sh        (exit 1 if anything is ✗)
# ------------------------------------------------------------------------------

set -uo pipefail

REPO="${REPO:-$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)}"
FAILED=0
ok() { echo "  ✓ $*"; }
bad() { echo "  ✗ $*"; FAILED=1; }
section() { echo; echo "=== $* ==="; }

# ------------------------------------------------------------------------------
section "Symlinks → repo"
# ------------------------------------------------------------------------------
check_link() {
  local dst="$1" src="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "$dst"
  elif [[ -L "$dst" ]]; then
    bad "$dst → $(readlink "$dst") (expected $src)"
  elif [[ -e "$dst" ]]; then
    bad "$dst exists but is not a symlink (shadows repo version)"
  else
    bad "$dst missing — run: bash setup.sh --links-only"
  fi
}
check_link "$HOME/.zshrc"                      "$REPO/zsh/.zshrc"
check_link "$HOME/.zprofile"                   "$REPO/zsh/.zprofile"
check_link "$HOME/.aliases.shrc"               "$REPO/zsh/aliases.shrc"
check_link "$HOME/.functions.shrc"             "$REPO/zsh/functions.shrc"
check_link "$HOME/.tmux.conf"                  "$REPO/tmux/.tmux.conf"
check_link "$HOME/.gitconfig"                  "$REPO/git-configs/.gitconfig"
check_link "$HOME/.gitignore_global"           "$REPO/git-configs/.gitignore_global"
check_link "$HOME/.config/nvim"                "$REPO/nvim"
check_link "$HOME/.config/starship.toml"       "$REPO/starship/starship.toml"
check_link "$HOME/.config/ghostty"             "$REPO/ghostty"
check_link "$HOME/.local/bin/tmux-sessionizer" "$REPO/scripts/tmux-sessionizer"
check_link "$HOME/.claude/settings.json"       "$REPO/claude/settings.json"
check_link "$HOME/.claude/CLAUDE.md"           "$REPO/claude/CLAUDE.md"
check_link "$HOME/.claude/keybindings.json"    "$REPO/claude/keybindings.json"
check_link "$HOME/.claude/statusline.sh"       "$REPO/claude/statusline.sh"
check_link "$HOME/.claude/hooks"               "$REPO/claude/hooks"
check_link "$HOME/.claude/skills"              "$REPO/claude/skills"
check_link "$HOME/.claude/agents"              "$REPO/claude/agents"

if [[ -L "$HOME/.tmux" ]]; then
  bad "$HOME/.tmux is a symlink → $(readlink "$HOME/.tmux") (plugins would be written there; make it a real dir)"
else
  ok "$HOME/.tmux is a real directory"
fi

# ------------------------------------------------------------------------------
section "Tools on PATH"
# ------------------------------------------------------------------------------
for cmd in zsh brew git nvim tmux starship fzf fd rg bat jq atuin zoxide lazygit gh delta shfmt shellcheck stylua fnm pyenv uv claude; do
  if command -v "$cmd" &>/dev/null; then ok "$cmd"; else bad "$cmd not found (Brewfile)"; fi
done

# ------------------------------------------------------------------------------
section "Binaries actually run (catches broken Homebrew dylibs)"
# ------------------------------------------------------------------------------
for cmd in bat delta fd rg; do
  if command -v "$cmd" &>/dev/null; then
    if "$cmd" --version &>/dev/null; then ok "$cmd --version"; else bad "$cmd crashes — try: brew upgrade libgit2 $cmd"; fi
  fi
done

# ------------------------------------------------------------------------------
section "Shell"
# ------------------------------------------------------------------------------
[[ "$(basename "${SHELL:-}")" == "zsh" ]] && ok "login shell: $SHELL" || bad "login shell is ${SHELL:-unset}; run: chsh -s \$(command -v zsh)"
dupes=$(zsh -ilc 'print -l $path' 2>/dev/null | sort | uniq -d | wc -l | tr -d ' ')
[[ "$dupes" == "0" ]] && ok "PATH has no duplicates" || bad "PATH has $dupes duplicate entries"
ctrl_r=$(zsh -ilc 'bindkey' 2>/dev/null | awk '$1=="\"^R\"" {print $2}')
[[ "$ctrl_r" == "atuin-search" ]] && ok "Ctrl-R → atuin" || bad "Ctrl-R → ${ctrl_r:-unbound} (expected atuin-search)"
[[ -d "$HOME/.oh-my-zsh" ]] && ok "oh-my-zsh" || bad "oh-my-zsh missing"
[[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]] && ok "fzf-tab plugin" || bad "fzf-tab plugin missing (setup.sh clones it)"

# ------------------------------------------------------------------------------
section "Git"
# ------------------------------------------------------------------------------
for key in user.name user.email core.pager; do
  val=$(git config --global "$key" 2>/dev/null)
  [[ -n "$val" ]] && ok "$key = $val" || bad "$key not set"
done

# ------------------------------------------------------------------------------
section "tmux"
# ------------------------------------------------------------------------------
if [[ -x "$HOME/.tmux/plugins/tpm/tpm" ]]; then
  ok "TPM"
  for p in tmux-sensible tmux-yank vim-tmux-navigator tmux-fzf tmux-battery tmux-resurrect tmux-continuum tmux; do
    [[ -n "$(ls -A "$HOME/.tmux/plugins/$p" 2>/dev/null)" ]] && ok "plugin $p" || bad "plugin $p not installed (prefix + I)"
  done
else
  bad "TPM missing — start tmux once (auto-installs) or re-run setup.sh"
fi

# ------------------------------------------------------------------------------
section "Neovim"
# ------------------------------------------------------------------------------
if command -v nvim &>/dev/null; then
  ok "$(nvim --version | head -1)"
  health=$(mktemp)
  if nvim --headless -c 'checkhealth lazy vim.lsp mason vim.provider' -c "w! $health" -c 'qa!' &>/dev/null; then
    errs=$(grep -c 'ERROR' "$health" || true)
    [[ "$errs" == "0" ]] && ok "checkhealth: no errors" || { bad "checkhealth: $errs ERROR line(s)"; grep -n 'ERROR' "$health" | head -10 | sed 's/^/      /'; }
  else
    bad "nvim --headless checkhealth failed to run"
  fi
  rm -f "$health"
fi

# ------------------------------------------------------------------------------
section "Claude Code"
# ------------------------------------------------------------------------------
if command -v jq &>/dev/null; then
  jq . "$REPO/claude/settings.json" &>/dev/null && ok "claude/settings.json is valid JSON" || bad "claude/settings.json is invalid JSON"
fi
[[ -x "$HOME/.claude/statusline.sh" ]] && ok "statusline executable" || bad "statusline.sh not executable"
if command -v claude &>/dev/null; then
  claude mcp get linear &>/dev/null && ok "MCP: linear (user scope)" || bad "MCP linear not registered (setup.sh step 9)"
fi

echo
if [[ $FAILED -eq 0 ]]; then echo "All checks passed."; else echo "Some checks failed — see docs/DEBUG.md."; exit 1; fi
