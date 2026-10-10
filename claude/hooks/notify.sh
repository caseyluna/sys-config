#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# notify.sh — Notification hook: desktop banner when Claude needs attention
# ------------------------------------------------------------------------------
# Fires on permission prompts / idle waits so you notice from another tmux pane.
# macOS: terminal-notifier (Brewfile), falls back to osascript.
# Linux: notify-send (libnotify, from scripts/linux/<distro>.sh).
# ------------------------------------------------------------------------------
input=$(cat)
msg=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
if [[ "$(uname -s)" == Linux ]]; then
  command -v notify-send &>/dev/null && notify-send -a "Claude Code" "Claude Code" "$msg" >/dev/null 2>&1
elif command -v terminal-notifier &>/dev/null; then
  terminal-notifier -title "Claude Code" -message "$msg" -group claude-code >/dev/null 2>&1
else
  osascript -e "display notification \"$msg\" with title \"Claude Code\"" >/dev/null 2>&1
fi
exit 0
