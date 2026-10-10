#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# lib.sh — Shared helpers for the Linux distro scripts (fedora.sh, ubuntu.sh)
# ------------------------------------------------------------------------------
# What it does:
#   Flag parsing (--gui / --no-gui / --yes), a $SUDO prefix, desktop detection,
#   and the distro-independent installs: Nerd Fonts (→ ~/.local/share/fonts)
#   and flatpak GUI apps (per-user Flathub). Sourced, never run directly.
#
# How to interact:
#   Distro scripts: source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"; parse_flags "$@"
#   Add a GUI app: append its Flathub id to FLATPAKS (Linux twin of a Brewfile cask).
# ------------------------------------------------------------------------------

# Flathub twins of the Brewfile GUI casks (no Linux build: notion, tuple, dockfix)
FLATPAKS=(
  io.dbeaver.DBeaverCommunity # cask dbeaver-community
  com.sublimetext.three       # cask sublime-text
  us.zoom.Zoom                # cask zoom
)
# Nerd Fonts release archives (ghostty/config uses JetBrainsMono Nerd Font)
NERD_FONTS=(JetBrainsMono Hack)

log() { echo "[linux] $*"; }
step() {
  echo
  echo "[linux] ===== $* ====="
}
err() { echo "[linux] ERROR: $*" >&2; }

# --gui / --no-gui force the desktop section; default is to detect a session
GUI=auto
parse_flags() {
  for arg in "$@"; do
    case "$arg" in
      --gui) GUI=1 ;;
      --no-gui) GUI=0 ;;
      --yes | -y) ;; # accepted for symmetry with setup.sh; package installs never prompt
      -h | --help)
        sed -n '2,30p' "$0"
        exit 0
        ;;
      *)
        err "Unknown flag: $arg (see --help)"
        exit 2
        ;;
    esac
  done
  if [[ $GUI == auto ]]; then
    if [[ -n "${XDG_CURRENT_DESKTOP:-}${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]]; then GUI=1; else GUI=0; fi
  fi
}

# Root runs package managers directly; everyone else goes through sudo
if [[ $(id -u) -eq 0 ]]; then
  SUDO=()
elif command -v sudo &>/dev/null; then
  SUDO=(sudo)
else
  err "Need root or sudo to install system packages."
  exit 1
fi

# Docker engine: start it (systemd hosts only — not containers) and let $USER use it
docker_post_install() {
  if [[ -d /run/systemd/system ]]; then
    "${SUDO[@]}" systemctl enable --now docker && log "docker: service enabled"
  fi
  local user
  user="$(id -un)"
  if [[ $user != root ]] && ! id -nG "$user" | grep -qw docker; then
    "${SUDO[@]}" usermod -aG docker "$user" && log "docker: added $user to group docker (log out/in to apply)"
  fi
}

install_nerd_fonts() {
  local dir="$HOME/.local/share/fonts/NerdFonts" font tmp
  for font in "${NERD_FONTS[@]}"; do
    if [[ -d "$dir/$font" ]]; then
      log "font $font: present"
      continue
    fi
    log "Installing $font Nerd Font..."
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/$font.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz"
    mkdir -p "$dir/$font"
    tar -xJf "$tmp/$font.tar.xz" -C "$dir/$font"
    rm -rf "$tmp"
  done
  command -v fc-cache &>/dev/null && fc-cache -f "$dir" >/dev/null
}

install_flatpaks() {
  if ! command -v flatpak &>/dev/null; then
    log "skip: flatpak not installed"
    return 0
  fi
  # --user: no sudo/polkit prompts, apps live in ~/.local/share/flatpak
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # One at a time: an app missing for this arch (Sublime is x86_64-only) must not block the rest
  local app
  for app in "${FLATPAKS[@]}"; do
    flatpak install --user -y --noninteractive flathub "$app" || log "flatpak $app: not available here — skipped"
  done
}
