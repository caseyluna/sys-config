#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# notify.sh — Notification hook: macOS banner when Claude needs attention
# ------------------------------------------------------------------------------
# Fires on permission prompts / idle waits so you notice from another tmux pane.
# Uses terminal-notifier (Brewfile) and falls back to osascript.
# ------------------------------------------------------------------------------
input=$(cat)
msg=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
if command -v terminal-notifier &>/dev/null; then
  terminal-notifier -title "Claude Code" -message "$msg" -group claude-code >/dev/null 2>&1
else
  osascript -e "display notification \"$msg\" with title \"Claude Code\"" >/dev/null 2>&1
fi
exit 0
