# Global instructions (all projects)

## Environment
- macOS (Apple Silicon), zsh, Homebrew, tmux, Neovim. Dotfiles live in `~/sys-config` (`$SYS_CONFIG`).
- Prefer `rg` over grep, `fd` over find, `bat` over cat, `jq`/`yq` for JSON/YAML, `uv` for Python.
- Python projects: `uv run` / `uv sync`; tests with `pytest`. Lint with `ruff`, types with `mypy`.

## Git
- Always check `git branch --show-current` before committing — confirm the branch is the one that owns the change.
- Commit messages: conventional commits (`fix(nvim): …`, `feat(zsh): …`). Keep subject ≤ 72 chars.
- Never `git push --force`; use `--force-with-lease` and only on branches I own.
- Never commit `.env*`, `*.pem`, `*.key`, or `.claude/settings.local.json`.
- PRs via `gh pr create`. Stacked PRs are rebased lowest-first (see `/stack-rebase`).

## Style
- Keep answers short; lead with the result, then the why. Code over prose.
- Match the surrounding code's style; files in my dotfiles start with a banner comment explaining what/how/where.
- Don't add dependencies without saying why and what they replace.
