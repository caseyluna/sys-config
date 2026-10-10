# ------------------------------------------------------------------------------
# .zprofile — Login-shell environment (PATH + env vars), loaded ONCE per login
# ------------------------------------------------------------------------------
# What it does:
#   Builds PATH exactly once (deduplicated) and exports the env vars every
#   program needs: Homebrew, pyenv shims, user bins, EDITOR. GUI apps and tmux
#   panes (login shells) get this too. Interactive-only things (prompt, aliases,
#   keybindings, completions) live in .zshrc.
#
# How to interact:
#   Edit in repo (zsh/.zprofile); ~/.zprofile is a symlink. Applies to new
#   login shells / after re-login. Add new PATH entries to the `path=(...)`
#   block — never `export PATH=...:$PATH` elsewhere.
#
# Location: ~/.zprofile (symlinked from repo)
# ------------------------------------------------------------------------------

# Repo root, resolved from this file's real path (works wherever the repo lives)
export SYS_CONFIG="${${(%):-%x}:A:h:h}"

# PATH as a deduplicated array: later `path+=` / `path=(x $path)` never add dupes
typeset -U path PATH

# Homebrew (Apple Silicon, Intel, Linuxbrew) — sets HOMEBREW_PREFIX and PATH
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

# pyenv shims (interactive init is in .zshrc)
export PYENV_ROOT="$HOME/.pyenv"

path=(
  "$PYENV_ROOT/shims"
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Python builds against Homebrew's OpenSSL (pyenv install)
export PYTHON_BUILD_HOMEBREW_OPENSSL_FORMULA=openssl@3
