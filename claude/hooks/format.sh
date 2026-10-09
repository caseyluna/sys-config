#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# format.sh — PostToolUse hook: format the file Claude just edited
# ------------------------------------------------------------------------------
# Mirrors Neovim's format-on-save (conform.nvim) so Claude's edits land in the
# same style. Silently skips when a formatter isn't installed. Never fails the
# tool call (always exits 0).
# ------------------------------------------------------------------------------
input=$(cat)
file=$(echo "$input" | jq -r '.tool_input.file_path // empty')
[[ -n "$file" && -f "$file" ]] || exit 0

have() { command -v "$1" &>/dev/null; }

case "$file" in
  *.lua)                have stylua && stylua "$file" ;;
  *.py)                 have ruff && { ruff check --select I --fix -q "$file"; ruff format -q "$file"; } ;;
  *.sh|*.bash|*.shrc|*.zsh) have shfmt && shfmt -w -i 2 -ci "$file" ;;
  *.tf|*.tfvars)        have terraform && terraform fmt "$file" ;;
  *.json|*.yaml|*.yml|*.md|*.css|*.html)
                        have prettier && prettier --log-level silent --write "$file" ;;
  *.toml)               have taplo && taplo fmt "$file" ;;
esac
exit 0
