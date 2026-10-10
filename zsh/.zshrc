# ------------------------------------------------------------------------------
# .zshrc — Interactive zsh configuration
# ------------------------------------------------------------------------------
# What it does (in order):
#   1. Oh My Zsh + plugins (git, docker, autosuggestions, syntax highlighting)
#   2. fzf-tab: fzf-powered Tab completion
#   3. Starship prompt
#   4. History settings
#   5. Tool hooks: direnv, zoxide, fzf (Ctrl-T/Alt-C), atuin (Ctrl-R), custom
#      fzf widgets (Ctrl-E files, Ctrl-O launcher), pyenv, fnm, kubectl, gcloud
#   6. Aliases + functions (zsh/aliases.shrc, zsh/functions.shrc)
#
# Same file on macOS and Linux: OS differences are `$OSTYPE` checks inline
# (darwin* / linux*); Linux gets pbcopy/pbpaste/open shims in functions.shrc.
#
# Key bindings owned here:  Ctrl-R atuin · Ctrl-T fzf files · Alt-C fzf cd ·
#                           Ctrl-E fzf file→buffer · Ctrl-O launcher · Tab fzf-tab
#
# How to interact:
#   Edit in repo (zsh/.zshrc); ~/.zshrc is a symlink. Reload: sz (source ~/.zshrc)
#   PATH/env changes go in .zprofile, not here.
#
# Location: ~/.zshrc (symlinked from repo)
# ------------------------------------------------------------------------------

# .zprofile normally ran first (login shell). If not (e.g. `zsh` from a
# non-login context), load it so PATH/SYS_CONFIG exist.
[[ -n "${SYS_CONFIG:-}" ]] || source "${${(%):-%x}:A:h}/.zprofile"

# ------------------------------------------------------------------------------
# 1. Oh My Zsh
# ------------------------------------------------------------------------------
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
# Per zsh version: /bin/zsh and Homebrew zsh compile incompatible .zwc files
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST-$ZSH_VERSION"

# Plugins: custom ones (fzf-tab, zsh-autosuggestions, fast-syntax-highlighting)
# are cloned into $ZSH_CUSTOM/plugins by setup.sh.
# Not used: vi-mode (conflicts with fzf keys), zsh-autocomplete (conflicts with fzf-tab)
plugins=(
  git
  docker
  docker-compose
  virtualenv
  zsh-autosuggestions
  fast-syntax-highlighting
)
[[ $OSTYPE == darwin* ]] && plugins+=(macos)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------------------
# 2. fzf-tab — must load after compinit (OMZ did it) and before other widgets
# ------------------------------------------------------------------------------
if [[ -f "${ZSH_CUSTOM:-$ZSH/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "${ZSH_CUSTOM:-$ZSH/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh"
  zstyle ':completion:*' menu no                      # fzf-tab owns Tab
  # BSD ls (macOS) colors with -G; GNU ls (Linux) reads -G as --no-group
  [[ $OSTYPE == darwin* ]] && _ls_preview='ls -G' || _ls_preview='ls --color=always'
  zstyle ':fzf-tab:complete:cd:*' fzf-preview "$_ls_preview \$realpath 2>/dev/null"
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview "$_ls_preview \$realpath 2>/dev/null"
  unset _ls_preview
  zstyle ':fzf-tab:*' fzf-flags '--height=50%' '--reverse' '--border=rounded'
  zstyle ':fzf-tab:*' switch-group ',' '.'            # , and . cycle completion groups
fi

# ------------------------------------------------------------------------------
# 3. Prompt — Starship (config: starship/starship.toml → ~/.config/starship.toml)
# ------------------------------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------------------------
# 4. History (atuin also keeps its own DB; this is the plain zsh file)
# ------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE EXTENDED_HISTORY

# ------------------------------------------------------------------------------
# 5. Tool hooks (each guarded so a missing tool never breaks the shell)
# ------------------------------------------------------------------------------
# direnv: auto-load .envrc
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# zoxide: z <dir>, zi (interactive)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# fzf: Ctrl-T (files), Alt-C (cd), ** completion. Sourced BEFORE atuin so atuin
# gets the final say on Ctrl-R.
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height=40% --reverse --border=rounded'
  export FZF_CTRL_T_OPTS="--preview 'bat --style=plain --color=always {} 2>/dev/null || head -100 {}'"
  export FZF_TMUX=1
  export FZF_TMUX_HEIGHT=40%
fi

# atuin: Ctrl-R history TUI (per-dir filter, exit codes). Up-arrow stays native.
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# Custom fzf widgets: Ctrl-E (insert file path), Ctrl-O (launcher)
[[ -f "$SYS_CONFIG/fzf/key-bindings.zsh" ]] && source "$SYS_CONFIG/fzf/key-bindings.zsh"

# pyenv (Python versions; venvs via uv)
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

# fnm: Node versions; --use-on-cd switches on .node-version/.nvmrc
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

# kubectl completion
command -v kubectl &>/dev/null && source <(kubectl completion zsh)

# gcloud: PATH + completion — Homebrew cask (macOS) or google-cloud-cli
# dnf/apt package (Linux: binary already in /usr/bin, completion in /usr/share|lib)
for _gc in ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/share/google-cloud-sdk"} /usr/share/google-cloud-sdk /usr/lib/google-cloud-sdk; do
  if [[ -f "$_gc/completion.zsh.inc" ]]; then
    [[ -f "$_gc/path.zsh.inc" ]] && source "$_gc/path.zsh.inc"
    source "$_gc/completion.zsh.inc"
    break
  fi
done
unset _gc

# ------------------------------------------------------------------------------
# 6. Aliases and functions
# ------------------------------------------------------------------------------
[[ -f "$HOME/.aliases.shrc" ]]   && source "$HOME/.aliases.shrc"
[[ -f "$HOME/.functions.shrc" ]] && source "$HOME/.functions.shrc"
