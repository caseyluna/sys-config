# Testing

Two scripts; no unit tests (config is declarative — "does it parse/load?" and "is the machine wired up?").

| Script | When | Checks |
|---|---|---|
| `bash scripts/lint.sh` | before commit; CI on every push/PR | `zsh -n` on zsh files · `bash -n` + `shellcheck` on scripts · tmux config parses on a private socket · Neovim config loads headless from the repo (`XDG_CONFIG_HOME`) · `stylua --check` on Lua · `jq` on JSON · docs coverage (below) |
| `bash scripts/validate.sh` | after `setup.sh` or after pulling | every symlink from INSTALL.md points into the repo · required tools on PATH · `bat`/`delta` execute · git identity + pager · TPM + plugins present · headless `checkhealth` has no ERROR |

| `python3 scripts/docs-check.py` | via `lint.sh` (warns locally, fails in CI) | every nvim `<leader>` key is in KEYS.md · every alias/function is in CHEATSHEET.md · exceptions in `docs/.docs-ignore` |

CI: `.github/workflows/lint.yml` runs `lint.sh` on `ubuntu-latest` for pushes to `main`/`dev` and all PRs.

Docs sync: `.github/workflows/docs-sync.yml` runs on PRs touching config — Claude edits `docs/` to match the diff, pushes a `docs: sync with config changes` commit to the PR branch, then re-runs lint. **Pull before continuing work on that branch.** One-time setup: `claude setup-token`, then `gh secret set CLAUDE_CODE_OAUTH_TOKEN`.

Clean-room: see [INSTALL.md](INSTALL.md#clean-room-test).
