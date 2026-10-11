#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# install.sh — One-line bootstrap for a brand-new machine (macOS or Linux)
# ------------------------------------------------------------------------------
# What it does: makes sure git exists, clones this repo (HTTPS — no SSH key on
#   a new machine), then runs setup.sh, passing your flags through. Re-running
#   it on a machine that already has the repo just pulls and re-runs setup.
# How to interact:
#   curl -fsSL https://raw.githubusercontent.com/caseyluna/sys-config/main/install.sh | bash
#   curl -fsSL …/install.sh | bash -s -- --yes --no-gui    # headless Linux server
#   SYS_CONFIG=~/code/sys-config curl … | bash              # clone somewhere else
# Afterwards: exec zsh, then use `task` (installed by setup.sh) — e.g. task doctor.
# Location: repo root. Must stay bash 3.2 compatible (stock macOS bash).
# ------------------------------------------------------------------------------

# Everything is inside main(), called on the last line, so a partially
# downloaded script can't run half of itself.
main() {
  set -euo pipefail
  local repo_url="https://github.com/caseyluna/sys-config.git"
  local dest="${SYS_CONFIG:-$HOME/sys-config}"
  say() { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
  die() {
    printf '\033[1;31m[install]\033[0m %s\n' "$*" >&2
    exit 1
  }

  # git: macOS ships a stub until the Command Line Tools are installed.
  if [[ "$(uname -s)" == Darwin ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
      say "Installing Xcode Command Line Tools (git, compiler) — a dialog will open."
      xcode-select --install >/dev/null 2>&1 || true
      die "Finish the Command Line Tools install, then run this command again."
    fi
  elif ! command -v git >/dev/null 2>&1; then
    say "git not found — installing it with the system package manager (needs sudo)."
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update -q && sudo apt-get install -y -q git curl
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y -q git curl
    else
      die "Install git, then run this command again."
    fi
  fi

  if [[ -d "$dest/.git" ]]; then
    say "Repo already at $dest — pulling latest."
    git -C "$dest" pull --ff-only || say "Couldn't fast-forward (local changes?) — using it as is."
  elif [[ -e "$dest" ]]; then
    die "$dest exists but isn't a git clone — move it aside or set SYS_CONFIG=<path>."
  else
    say "Cloning $repo_url → $dest"
    git clone -q "$repo_url" "$dest"
  fi

  say "Running setup.sh $*"
  # `curl | bash` makes stdin the download stream; give setup.sh the terminal
  # so its prompts (chsh, Homebrew) can be answered. No terminal (CI) → as is.
  if (exec </dev/tty) 2>/dev/null; then
    REPO="$dest" bash "$dest/setup.sh" "$@" </dev/tty
  else
    REPO="$dest" bash "$dest/setup.sh" "$@"
  fi

  say "Done. Next: exec zsh   then   task doctor"
}

main "$@"
