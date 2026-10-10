# ------------------------------------------------------------------------------
# Brewfile — Homebrew formulae and casks
# ------------------------------------------------------------------------------
# What it does:
#   Declares every Homebrew package the dev environment needs. setup.sh runs
#   `brew bundle --no-upgrade --file=Brewfile`. Each section says *why* the
#   packages are there so pruning stays easy.
#
# How to interact:
#   Add a line, then: brew bundle --file="$SYS_CONFIG/Brewfile"
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
brew "terminal-notifier"      # macOS notifications from scripts / Claude hooks

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
brew "asciinema"              # Record terminal sessions
brew "mosh"                   # Roaming SSH
brew "ranger"                 # Terminal file browser
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
brew "pyenv-virtualenv"       # pyenv venv plugin
brew "uv"                     # Fast package/venv manager (uvv, uvs, uvr, …)
brew "python@3.13"            # Homebrew python for formulae that need it
brew "ipython"
brew "poetry"                 # For projects that still use it

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
cask "dbeaver-community"      # GUI SQL client

# ------------------------------------------------------------------------------
# Containers, Kubernetes, cloud, infra
# ------------------------------------------------------------------------------
brew "docker", link: false    # CLI (Docker Desktop cask provides the daemon)
brew "docker-completion"
brew "lazydocker"             # Docker TUI (ld)
brew "hadolint"               # Dockerfile linter
brew "kubernetes-cli"         # kubectl (kx, kns, kl, kex)
brew "helm"
brew "k9s"                    # Kubernetes TUI (homebrew-core)
brew "go-task"                # Taskfile runner
brew "hashicorp/tap/terraform" # tfi/tfp/tfa…, terraformls in nvim
cask "gcloud-cli"             # gcloud / bq (functions.shrc gcpp, query-gcp)
cask "docker-desktop"

# ------------------------------------------------------------------------------
# Docs & linting (non-Mason)
# ------------------------------------------------------------------------------
brew "markdownlint-cli"       # scripts + nvim-lint
brew "marksman"               # Markdown LSP
brew "mdcat"                  # Render markdown in terminal
brew "yamllint"

# ------------------------------------------------------------------------------
# Other languages (occasional — remove if you stop using them)
# ------------------------------------------------------------------------------
brew "go"                     # go-task plugins, occasional tooling
brew "rust"                   # cargo for the odd Rust CLI; Mason cargo builds
brew "r"                      # R (alias R=…)
brew "openblas"               # Linear algebra for R / NumPy
brew "llvm"                   # clang toolchain for native builds

# ------------------------------------------------------------------------------
# Terminal emulator + fonts (ghostty/config expects JetBrainsMono Nerd Font)
# ------------------------------------------------------------------------------
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"

# ------------------------------------------------------------------------------
# AI tooling
# ------------------------------------------------------------------------------
cask "claude-code"            # Claude Code CLI (config in claude/, linked by setup.sh)

# ------------------------------------------------------------------------------
# GUI apps
# ------------------------------------------------------------------------------
cask "notion"
cask "tuple"
cask "zoom"
cask "dockfix"
