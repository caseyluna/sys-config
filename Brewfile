# ------------------------------------------------------------------------------
# Brewfile — Homebrew formulae and casks
# ------------------------------------------------------------------------------
# What it does:
#   Declares every Homebrew package the dev environment needs. setup.sh runs
#   `brew bundle --no-upgrade --file=Brewfile`. Each section says *why* the
#   packages are there so pruning stays easy.
#
#   Same file on macOS and Linux (Homebrew on Linux). Anything that only exists
#   on macOS (casks, macOS-only formulae) sits in an `if OS.mac?` block; the
#   Linux equivalents come from the distro script (scripts/linux/<distro>.sh).
#
# How to interact:
#   Add a line, then: brew bundle --file="$SYS_CONFIG/Brewfile"
#   macOS-only? Put it in an `if OS.mac?` block and add the Linux equivalent
#   to scripts/linux/fedora.sh + ubuntu.sh.
#   See what's installed but not listed here:  brewdiff   (alias)
#   Formatters/linters/LSPs for Neovim are NOT here — Mason installs them
#   (nvim/lua/cluna/plugins/mason.lua).
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Taps (setup.sh runs `brew trust` on each — Homebrew 6 refuses untrusted taps)
# ------------------------------------------------------------------------------
tap "hashicorp/tap"           # Official Terraform builds (core formula is stale/removed)

# ------------------------------------------------------------------------------
# Shell — zsh, prompt, history, navigation (used by zsh/.zshrc)
# ------------------------------------------------------------------------------
brew "zsh"                    # Shell (chsh'd to by setup.sh)
brew "starship"               # Prompt (starship/starship.toml)
brew "atuin"                  # Shell history TUI — owns Ctrl-R
brew "fzf"                    # Fuzzy finder — Ctrl-T / Alt-C / fzf-tab / widgets
brew "zoxide"                 # Smarter cd (z, zi)
brew "direnv"                 # Per-directory .envrc
brew "zsh-completions"        # Extra completion definitions
brew "terminal-notifier" if OS.mac? # macOS notifications (Linux: notify-send, distro pkg)

# ------------------------------------------------------------------------------
# Core CLI — the tools aliases/functions/widgets assume exist
# ------------------------------------------------------------------------------
brew "bat"                    # cat with highlighting (alias cat=bat; fzf previews)
brew "fd"                     # Fast find (Ctrl-E / Ctrl-O widgets, telescope)
brew "ripgrep"                # Fast grep (rgf, telescope live_grep)
brew "jq"                     # JSON (jqf)
brew "yq"                     # YAML/TOML counterpart to jq
brew "tree"                   # Directory trees (fzf previews)
brew "tlrc"                   # tldr pages (Rust client)
brew "btop"                   # Resource monitor
brew "coreutils"              # GNU coreutils (grealpath, gsort, …)
brew "curl"
brew "wget"
brew "bzip2"
brew "xz"
brew "zstd"

# ------------------------------------------------------------------------------
# Terminal multiplexer + editor
# ------------------------------------------------------------------------------
brew "tmux"                   # tmux/.tmux.conf (plugins via TPM, cloned by setup.sh)
brew "neovim"                 # nvim/ (plugins via lazy.nvim, bootstrapped on first run)
brew "tree-sitter"            # Treesitter CLI (parser builds)
brew "stylua"                 # Lua formatter — also used by scripts/lint.sh + Claude hook
brew "shellcheck"             # Shell linter — scripts/lint.sh + nvim-lint
brew "shfmt"                  # Shell formatter — conform + Claude hook

# ------------------------------------------------------------------------------
# Git & GitHub
# ------------------------------------------------------------------------------
brew "git-delta"              # Pager for git diff (git-configs/.gitconfig)
brew "git-lfs"                # Required by .gitconfig [filter "lfs"]
brew "gh"                     # GitHub CLI (gcpr, gprco, octo.nvim)
brew "lazygit"                # Git TUI (lg, prefix+g in tmux, <leader>lg in nvim)
brew "pre-commit"             # Git hook framework
brew "commitizen"             # Conventional commits helper

# ------------------------------------------------------------------------------
# Python (primary language) — pyenv for interpreters, uv for projects
# ------------------------------------------------------------------------------
brew "pyenv"                  # Python versions (setup.sh installs + sets global 3.13)
brew "uv"                     # Fast package/venv manager (uvv, uvs, uvr, …)
brew "python@3.13"            # Homebrew python for formulae that need it
brew "ipython"

# ------------------------------------------------------------------------------
# Node — only for npm-distributed tools (Mason LSPs/prettier, Claude Code deps)
# ------------------------------------------------------------------------------
brew "fnm"                    # Node version manager (setup.sh installs LTS); do NOT add brew "node"

# ------------------------------------------------------------------------------
# Data & databases
# ------------------------------------------------------------------------------
brew "duckdb"                 # csvq / pq helpers; local SQL on files
brew "sqlite"
brew "mycli"                  # MySQL CLI (phil-db-* functions)
cask "dbeaver-community" if OS.mac? # GUI SQL client (Linux: flatpak, distro script)

# ------------------------------------------------------------------------------
# Containers, Kubernetes, cloud, infra
# ------------------------------------------------------------------------------
if OS.mac?
  brew "docker", link: false  # CLI (Docker Desktop cask provides the daemon)
  brew "docker-completion"    # (Linux: docker engine + CLI from the distro script)
end
brew "lazydocker"             # Docker TUI (ld)
brew "hadolint"               # Dockerfile linter
brew "kubernetes-cli"         # kubectl (kx, kns, kl, kex)
brew "helm"
brew "k9s"                    # Kubernetes TUI (homebrew-core)
brew "go-task"                # Taskfile runner
brew "hashicorp/tap/terraform" # tfi/tfp/tfa…, terraformls in nvim
if OS.mac?
  cask "gcloud-cli"           # gcloud / bq (Linux: google-cloud-cli, distro script)
  cask "docker-desktop"
end

# ------------------------------------------------------------------------------
# Docs & linting (non-Mason)
# ------------------------------------------------------------------------------
brew "markdownlint-cli"       # scripts + nvim-lint
brew "marksman"               # Markdown LSP
brew "yamllint"

# ------------------------------------------------------------------------------
# Other languages (occasional — remove if you stop using them)
# ------------------------------------------------------------------------------
brew "r"                      # R (alias R=…)
brew "openblas"               # Linear algebra for R / NumPy

# ------------------------------------------------------------------------------
# Terminal emulator + fonts (ghostty/config expects JetBrainsMono Nerd Font)
# Linux: ghostty + Nerd Fonts come from the distro script.
# ------------------------------------------------------------------------------
if OS.mac?
  cask "ghostty"
  cask "font-jetbrains-mono-nerd-font"
end

# ------------------------------------------------------------------------------
# AI tooling
# ------------------------------------------------------------------------------
# Claude Code CLI (config in claude/, linked by setup.sh).
# Linux: setup.sh step 9 runs the native installer (→ ~/.local/bin/claude).
cask "claude-code" if OS.mac?

# ------------------------------------------------------------------------------
# GUI apps (Linux: DBeaver / Zoom as flatpaks via the distro script)
# ------------------------------------------------------------------------------
if OS.mac?
  cask "notion"
  cask "tuple"
  cask "zoom"
  cask "dockfix"
end
