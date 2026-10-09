# ------------------------------------------------------------------------------
# key-bindings.zsh — Custom fzf key bindings and widgets
# ------------------------------------------------------------------------------
# Sourced by .zshrc AFTER `fzf --zsh` (Ctrl-T files, Alt-C cd) and atuin
# (Ctrl-R). Nothing here may rebind those three.
#   Ctrl-E  → same as Ctrl-T (fzf's file widget: fd + bat preview, Tab = multi)
#   Ctrl-O  → launcher-widget.zsh (files / directories / history)
# Add a widget: drop a *-widget.zsh file here that defines + binds a zle widget.
# ------------------------------------------------------------------------------

[[ -o interactive ]] || return 0

# Ctrl-E: alias of fzf's native Ctrl-T widget (kept for muscle memory)
if (( $+widgets[fzf-file-widget] )); then
  bindkey -M emacs '^E' fzf-file-widget
  bindkey -M viins '^E' fzf-file-widget
  bindkey -M vicmd '^E' fzf-file-widget
fi

for _w in "${${(%):-%x}:A:h}"/*-widget.zsh; do
  source "$_w"
done
unset _w
