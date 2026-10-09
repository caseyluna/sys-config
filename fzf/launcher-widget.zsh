# ------------------------------------------------------------------------------
# launcher-widget.zsh — Ctrl-O: files / directories / history launcher
# ------------------------------------------------------------------------------
# Description:
#   A single widget that lets you:
#   - Open recent files (via fd)
#   - Jump to recent directories
#   - Re-run previous commands
#   with context-aware preview.
# ------------------------------------------------------------------------------

fzf-launcher-widget() {
  local choice
  local preview=""

  # Use fd and ripgrep if available
  local file_cmd="fd --type f --hidden --follow --exclude .git"
  local dir_cmd="fd --type d --hidden --follow --exclude .git"
  local hist_cmd="history | sort -nr | sed 's/ *[0-9]* *//'"

  choice=$(printf "%s\n" \
    "📄 Files" \
    "📁 Directories" \
    "📜 History" |
    fzf --prompt="Launcher ❯ " --height=40% --border --reverse)

  case "$choice" in
    "📄 Files")
      preview="bat --style=plain --color=always {} || head -n 100 {}"
      BUFFER="$($file_cmd | fzf --preview="$preview" --height=80% --reverse --prompt='Files ❯ ')"
      ;;
    "📁 Directories")
      BUFFER="cd $($dir_cmd | fzf --preview='tree -L 2 {}' --height=80% --reverse --prompt='Directories ❯ ')"
      ;;
    "📜 History")
      BUFFER="$($hist_cmd | fzf --preview-window=hidden --height=80% --reverse --prompt='History ❯ ')"
      ;;
    *)
      return 0
      ;;
  esac

  zle accept-line
}

zle -N fzf-launcher-widget
bindkey -M emacs '^O' fzf-launcher-widget
bindkey -M vicmd '^O' fzf-launcher-widget
bindkey -M viins '^O' fzf-launcher-widget
