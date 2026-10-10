#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# statusline.sh — Claude Code status line: model · dir · git branch · context %
# ------------------------------------------------------------------------------
# Claude pipes a JSON blob on stdin (model, workspace, context_window, cost).
# Wired via claude/settings.json "statusLine". Keep it fast: no network calls.
# ------------------------------------------------------------------------------
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
used=$(echo "$input" | jq -r '
  (.context_window.used_percentage
   // (if (.context_window.current_usage // 0) > 0 and (.context_window.context_window_size // 0) > 0
       then ((.context_window.current_usage.input_tokens // .context_window.current_usage) * 100 / .context_window.context_window_size)
       else empty end)) | floor' 2>/dev/null)

branch=""
if [[ -n "$dir" ]] && git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && branch="  $branch"
fi

short_dir="${dir/#$HOME/~}"
ctx=""
[[ -n "$used" ]] && ctx="  ·  ctx ${used}%"

printf '%s  ·  %s%s%s' "$model" "$short_dir" "$branch" "$ctx"
