#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# bootstrap-scope.sh — How much Linux bootstrap does this diff need? (CI helper)
# ------------------------------------------------------------------------------
# Prints `mode=full|quick` and `reason=…` (GITHUB_OUTPUT format) for the diff
# BASE...HEAD. linux-bootstrap.yml runs the ~15 min full install (Homebrew +
# whole Brewfile + pyenv build) only for `full`; `quick` is links + OMZ + tmux
# plugins + a clean interactive zsh/tmux start (~1-2 min).
#
#   full  — Brewfile, scripts/linux/**, this script, linux-bootstrap.yml, or a
#           setup.sh change outside the link table (link_file / stale-link /
#           comment lines only → quick)
#   quick — anything else (zsh/, tmux/, validate.sh, link-only setup.sh, …)
# Events that always mean full (weekly schedule, `full-bootstrap` label, manual
# run with mode=full) are decided in the workflow, not here.
#
# Usage: bash scripts/bootstrap-scope.sh origin/dev [HEAD]
# ------------------------------------------------------------------------------

set -euo pipefail

base="${1:?usage: bootstrap-scope.sh <base-ref> [head-ref]}"
head="${2:-HEAD}"

say() {
  echo "mode=$1"
  echo "reason=$2"
  exit 0
}

changed=$(git diff --name-only "$base...$head")

while IFS= read -r f; do
  case "$f" in
    Brewfile) say full "Brewfile changed" ;;
    scripts/linux/*) say full "$f changed (distro packages)" ;;
    scripts/bootstrap-scope.sh | .github/workflows/linux-bootstrap.yml) say full "$f changed (the check itself)" ;;
  esac
done <<<"$changed"

if grep -qx 'setup.sh' <<<"$changed"; then
  # Changed lines only, minus diff headers; link-table edits don't need a reinstall
  other=$(git diff -U0 "$base...$head" -- setup.sh |
    grep -E '^[+-]' | grep -vE '^(\+\+\+|---) ' |
    grep -vE '^[+-][[:space:]]*(link_file[[:space:]]|for stale in |#|$)' || true)
  [[ -n "$other" ]] && say full "setup.sh install steps changed"
  say quick "setup.sh link table only"
fi

say quick "no install inputs changed (Brewfile, setup.sh install steps, scripts/linux)"
