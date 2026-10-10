#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# code-session.sh — Tmux "code" session: Neovim (main) + terminal + Claude Code
# ------------------------------------------------------------------------------
# What it does:
#   Creates or attaches to a tmux session named "code" with:
#     - Main (top-left): Neovim
#     - Bottom-left: shell terminal
#     - Right (full height): Claude Code (default: claudecode; override with CODE_RIGHT_CMD)
#   Run:  dev
#
# Layout:
#     [ Neovim (top)   ] [ Claude Code (full height) ]
#     [ Terminal       ]
#
# How to adjust:
#   CODE_BOTTOM_PCT (default 25), CODE_RIGHT_PCT (default 30), CODE_RIGHT_CMD (default claudecode).
# ------------------------------------------------------------------------------

set -euo pipefail

SESSION_NAME="${CODE_SESSION_NAME:-code}"
BOTTOM_PCT="${CODE_BOTTOM_PCT:-25}"
RIGHT_PCT="${CODE_RIGHT_PCT:-30}"
# After claudecode exits, keep pane open with a shell (so pane doesn't disappear)
RIGHT_CMD="${CODE_RIGHT_CMD:-zsh -ic 'claude; exec zsh'}"

# If session exists: switch or attach (no nesting when already in tmux)
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$SESSION_NAME"
  else
    exec tmux attach-session -t "$SESSION_NAME"
  fi
  exit 0
fi

# Pane 0: Neovim (main) — use vv alias via interactive zsh
tmux new-session -s "$SESSION_NAME" -d zsh -ic 'vv'

# All layout commands target the new session (so "tmux -> dev" works from any session)
# Use explicit pane target so the right pane is always created in session "code".
T="$SESSION_NAME:0.0"

# Pane 1: full-height right pane = Claude Code (split pane 0 to the right)
tmux split-window -t "$T" -h -l "${RIGHT_PCT}%" "$RIGHT_CMD"

# Pane 2: bottom-left = terminal (split original pane 0 vertically)
tmux split-window -t "$T" -v -l "${BOTTOM_PCT}%"

if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$SESSION_NAME"
else
  exec tmux attach-session -t "$SESSION_NAME"
fi
