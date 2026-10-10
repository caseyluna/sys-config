#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# ubuntu.sh — System packages for Ubuntu (and Debian, Pop!_OS, Mint)
# ------------------------------------------------------------------------------
# What it does (idempotent; setup.sh runs it before Homebrew on Ubuntu/Debian):
#   1. base     — build-essential, procps/file (Homebrew), zsh, Python build
#                 headers (pyenv compiles against system libs on Linux)
#   2. desktop  — clipboard (wl-clipboard, xclip) for tmux-yank / nvim / pbcopy
#                 shim, notify-send for the Claude notify hook
#   3. docker   — docker.io + compose v2 + buildx, service on, $USER in group docker
#   4. gcloud   — Google's apt repo → google-cloud-cli (Brewfile cask on macOS)
#   5. gui      — ghostty (snap), Nerd Fonts, flatpak apps   (desktop only)
# The CLI toolchain itself (nvim, tmux, fzf, rg, bat, fd, …) comes from the
# Brewfile, so names and versions match macOS (no batcat / fdfind).
#
# Usage:
#   bash scripts/linux/ubuntu.sh            # auto-detects a desktop session
#   bash scripts/linux/ubuntu.sh --no-gui   # server / container / WSL
#   bash scripts/linux/ubuntu.sh --gui      # force GUI apps (e.g. over SSH)
# ------------------------------------------------------------------------------

set -euo pipefail
# shellcheck source=scripts/linux/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
parse_flags "$@"

export DEBIAN_FRONTEND=noninteractive
APT=("${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends)

step "ubuntu: base"
"${SUDO[@]}" apt-get update -q
"${APT[@]}" build-essential procps curl file git zsh ca-certificates gnupg \
  tar xz-utils unzip fontconfig \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses-dev \
  tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev uuid-dev libgdbm-dev

step "ubuntu: desktop integration"
"${APT[@]}" wl-clipboard xclip libnotify-bin

step "ubuntu: docker"
if command -v docker &>/dev/null; then
  log "docker: present ($(docker --version 2>/dev/null))"
else
  "${APT[@]}" docker.io
  # Ubuntu names; Debian ships compose/buildx differently — best effort
  "${APT[@]}" docker-compose-v2 docker-buildx || log "docker: compose v2 / buildx not in this release's repos"
  docker_post_install
fi

step "ubuntu: gcloud"
if command -v gcloud &>/dev/null; then
  log "gcloud: present"
else
  curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg |
    "${SUDO[@]}" gpg --dearmor --yes -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |
    "${SUDO[@]}" tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
  "${SUDO[@]}" apt-get update -q
  "${APT[@]}" google-cloud-cli
fi

if [[ $GUI -eq 1 ]]; then
  step "ubuntu: gui"
  if command -v ghostty &>/dev/null; then
    log "ghostty: present"
  elif command -v snap &>/dev/null; then
    "${SUDO[@]}" snap install ghostty --classic
  else
    log "ghostty: no snapd — see https://ghostty.org/docs/install/binary#linux-(official-and-community)"
  fi
  "${APT[@]}" flatpak
  install_nerd_fonts
  install_flatpaks
else
  log "skip: gui (no desktop session; pass --gui to force)"
fi

log "Ubuntu system packages done."
