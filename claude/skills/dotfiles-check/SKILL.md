---
name: dotfiles-check
description: Validate the sys-config dotfiles repo — lint shell/lua/tmux configs, verify symlinks, and run a headless Neovim checkhealth; summarize anything red.
---

# dotfiles-check

Run from the repo root (`$SYS_CONFIG`, default `~/sys-config`). Each step is read-only.

1. `bash scripts/lint.sh` — zsh/bash syntax, tmux parse, nvim config load, shellcheck, stylua.
2. `bash scripts/validate.sh` — symlinks point into the repo, required tools on PATH, dyld smoke tests.
3. `nvim --headless -c 'checkhealth vim.lsp lazy mason' -c 'w! /tmp/checkhealth.txt' -c 'qa!'` then
   `rg -n 'ERROR|WARNING' /tmp/checkhealth.txt` — report every ERROR; WARNINGs only if actionable.
4. `brew bundle check --file=Brewfile` — anything missing from the Brewfile install.

Report as a short table: **check · status · fix**. If everything passes say so in one line.
Do not edit files unless asked; propose the fix with the file:line.
