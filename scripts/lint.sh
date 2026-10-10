#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# lint.sh — Config syntax/load checks (no install, no symlinks needed)
# ------------------------------------------------------------------------------
# Run before committing and in CI. Checks:
#   zsh -n        zsh/*, fzf/*
#   bash -n       setup.sh, scripts/*.sh, claude/*.sh, claude/hooks/*.sh
#   shell lint    shellcheck on the same files (if installed)
#   bash 3.2      setup.sh avoids bash 4+ syntax (fresh Mac = /bin/bash 3.2)
#   tmux          config parses on a private socket
#   nvim          config loads headless from the repo
#   stylua        --check nvim/ (if installed)
#   jq            every .json in the repo parses
#   docs          keymaps/aliases/functions are in docs/ (scripts/docs-check.py;
#                 warning locally, failure in CI — pr-autofix.yml writes them)
# Usage: bash scripts/lint.sh   → exit 0 all good, 1 otherwise
# ------------------------------------------------------------------------------

set -uo pipefail

REPO="${REPO:-$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)}"
FAILED=0
log() { echo "[lint] $*"; }
ok() { echo "[lint]   OK   $*"; }
fail() { echo "[lint]   FAIL $*"; FAILED=1; }
skip() { echo "[lint]   skip $*"; }

ZSH_FILES=("$REPO"/zsh/.zshrc "$REPO"/zsh/.zprofile "$REPO"/zsh/aliases.shrc "$REPO"/zsh/functions.shrc "$REPO"/fzf/*.zsh)
BASH_FILES=("$REPO"/setup.sh "$REPO"/scripts/*.sh "$REPO"/scripts/tmux-sessionizer "$REPO"/claude/statusline.sh "$REPO"/claude/hooks/*.sh)

log "zsh syntax"
for f in "${ZSH_FILES[@]}"; do
  zsh -n "$f" 2>/dev/null && ok "$f" || fail "$f"
done

log "bash syntax"
for f in "${BASH_FILES[@]}"; do
  bash -n "$f" 2>/dev/null && ok "$f" || fail "$f"
done

log "bash 3.2 compat (setup.sh runs before Homebrew bash exists)"
if b4=$(grep -nE 'declare -[An]|local -A|mapfile|readarray|\$\{[A-Za-z_]+(,,|\^\^)|&>>|coproc' "$REPO/setup.sh"); then
  fail "setup.sh uses bash 4+ syntax: $b4"
else
  ok "setup.sh"
fi

log "shellcheck"
if command -v shellcheck &>/dev/null; then
  for f in "${BASH_FILES[@]}"; do
    shellcheck -x --severity=warning "$f" && ok "$f" || fail "$f"
  done
else
  skip "shellcheck not installed"
fi

log "tmux config"
if command -v tmux &>/dev/null; then
  sock=$(mktemp -u)
  tmux -f "$REPO/tmux/.tmux.conf" -S "$sock" start-server \; kill-server 2>/dev/null && ok "tmux/.tmux.conf" || fail "tmux/.tmux.conf"
  rm -f "$sock"
else
  skip "tmux not installed"
fi

log "nvim config load"
if command -v nvim &>/dev/null; then
  if XDG_CONFIG_HOME="$REPO" nvim --headless +qa 2>/dev/null; then ok "nvim/"; else fail "nvim/ (XDG_CONFIG_HOME=$REPO nvim --headless +qa)"; fi
else
  skip "nvim not installed"
fi

log "stylua"
if command -v stylua &>/dev/null; then
  stylua --check "$REPO/nvim" &>/dev/null && ok "nvim/ formatted" || fail "nvim/ needs: stylua nvim/"
else
  skip "stylua not installed"
fi

log "json"
if command -v jq &>/dev/null; then
  while IFS= read -r f; do
    jq . "$f" &>/dev/null && ok "$f" || fail "$f"
  done < <(find "$REPO" -name '*.json' -not -path '*/.git/*' -not -path '*/.tmux/*')
else
  skip "jq not installed"
fi

log "docs"
if command -v python3 &>/dev/null; then
  if out=$(python3 "$REPO/scripts/docs-check.py"); then
    ok "docs/ covers all keymaps, aliases, functions"
  elif [[ -n "${CI:-}" ]]; then
    echo "$out"; fail "docs/ out of date (python3 scripts/docs-check.py)"
  else
    echo "$out"; echo "[lint]   warn docs/ out of date — CI fails until pr-autofix (or you) updates them"
  fi
else
  skip "python3 not installed"
fi

echo
if [[ $FAILED -eq 0 ]]; then log "All checks passed."; exit 0; else log "Some checks failed."; exit 1; fi
