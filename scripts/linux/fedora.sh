#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# fedora.sh — System packages for Fedora (and dnf-based RHEL/Rocky/Alma)
# ------------------------------------------------------------------------------
# What it does (idempotent; setup.sh runs it before Homebrew on Fedora):
#   1. base     — C toolchain, procps/file (Homebrew), zsh + chsh, Python build
#                 headers (pyenv compiles against system libs on Linux)
#   2. desktop  — clipboard (wl-clipboard, xclip) for tmux-yank / nvim / pbcopy
#                 shim, notify-send for the Claude notify hook
#   3. docker   — moby-engine + compose, service on, $USER in group docker
#   4. gcloud   — Google's dnf repo → google-cloud-cli (Brewfile cask on macOS)
#   5. gui      — ghostty (COPR), Nerd Fonts, flatpak apps   (desktop only)
# The CLI toolchain itself (nvim, tmux, fzf, rg, …) comes from the Brewfile so
# versions match macOS.
#
# Usage:
#   bash scripts/linux/fedora.sh            # auto-detects a desktop session
#   bash scripts/linux/fedora.sh --no-gui   # server / container / WSL
#   bash scripts/linux/fedora.sh --gui      # force GUI apps (e.g. over SSH)
# Atomic variants (Silverblue/Kinoite) use rpm-ostree — not supported here.
# ------------------------------------------------------------------------------

set -euo pipefail
# shellcheck source=scripts/linux/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
parse_flags "$@"

DNF=("${SUDO[@]}" dnf install -y --setopt=install_weak_deps=False)

step "fedora: base"
"${DNF[@]}" @development-tools gcc gcc-c++ make patch \
  procps-ng curl file git zsh util-linux-user which tar xz unzip fontconfig \
  zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel \
  tk-devel libffi-devel xz-devel libuuid-devel gdbm-devel ncurses-devel libnsl2

step "fedora: desktop integration"
"${DNF[@]}" wl-clipboard xclip libnotify

step "fedora: docker"
if command -v docker &>/dev/null; then
  log "docker: present ($(docker --version 2>/dev/null))"
else
  "${DNF[@]}" moby-engine
  "${DNF[@]}" docker-compose docker-buildx || log "docker: compose / buildx not in this release's repos"
  docker_post_install
fi

step "fedora: gcloud"
if command -v gcloud &>/dev/null; then
  log "gcloud: present"
else
  "${SUDO[@]}" tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null <<EOF
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-$(uname -m)
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
  "${DNF[@]}" libxcrypt-compat google-cloud-cli
fi

if [[ $GUI -eq 1 ]]; then
  step "fedora: gui"
  if ! command -v ghostty &>/dev/null; then
    "${DNF[@]}" 'dnf-command(copr)'
    "${SUDO[@]}" dnf copr enable -y scottames/ghostty
    "${DNF[@]}" ghostty
  fi
  "${DNF[@]}" flatpak
  install_nerd_fonts
  install_flatpaks
else
  log "skip: gui (no desktop session; pass --gui to force)"
fi

log "Fedora system packages done."
