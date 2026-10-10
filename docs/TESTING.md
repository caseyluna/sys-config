# Testing

Two scripts; no unit tests (config is declarative — "does it parse/load?" and "is the machine wired up?").

| Script | When | Checks |
|---|---|---|
| `bash scripts/lint.sh` | before commit; CI on every push/PR | `zsh -n` on zsh files · `bash -n` + `shellcheck` on scripts · no bash 4+ syntax in `setup.sh`/`install.sh` · tmux config parses on a private socket · Neovim config loads headless from the repo (`XDG_CONFIG_HOME`) · `stylua --check` on Lua · `jq` on JSON · docs coverage (below) |
| `bash scripts/validate.sh` | after `setup.sh` or after pulling | every symlink from INSTALL.md points into the repo · required tools on PATH · `bat`/`delta` execute · git identity + pager · TPM + plugins present · headless `checkhealth` has no ERROR |

| `python3 scripts/docs-check.py` | via `lint.sh` (warns locally, fails in CI) | every nvim `<leader>` key is in KEYS.md · every alias/function is in CHEATSHEET.md · exceptions in `docs/.docs-ignore` |

CI: `.github/workflows/lint.yml` runs `lint.sh` (+ `ruby -c Brewfile`) on `ubuntu-latest` for pushes to `main`/`dev` and all PRs.

**Linux bootstrap** (`.github/workflows/linux-bootstrap.yml`, on PRs touching `setup.sh`, `Brewfile`, `scripts/linux/`, `zsh/`, `tmux/`, `validate.sh`): `scripts/bootstrap-scope.sh` reads the diff and picks a mode (shown in the run summary):

| Mode | When | What runs |
|---|---|---|
| **full** (~15 min) | `Brewfile`, `scripts/linux/**`, `setup.sh` install steps, the check itself · weekly (Mon 09:00 UTC, upstream drift) · `full-bootstrap` label · manual run | `bash setup.sh --yes --no-gui` on an Ubuntu 24.04 runner and in a `fedora:latest` container (non-root sudo user), `validate.sh` (report only — no real login session in CI), interactive `zsh -il` start |
| **quick** (~2 min) | anything else in the paths above (zsh/tmux edits, link-table-only `setup.sh`) | links + Oh My Zsh + tmux plugins on Ubuntu without Homebrew; interactive zsh (real pty) must print nothing, tmux must start |

Force the full install on a PR: add the `full-bootstrap` label. Preview the decision locally: `bash scripts/bootstrap-scope.sh origin/dev`.

| `python3 scripts/smoke.py [nvim\|tmux\|zsh]` | before commit (~15s); CI on config PRs | each tool starts for real with no errors · `.py .sh .sql .tf .lua .md` open cleanly and every installed LSP attaches · no two sources map the same nvim key, no `<Space>x` that's a prefix of `<Space>xy` · no plugin rebinds a tmux.conf key · battery placeholders resolved · zsh widgets (`^R` atuin, `^E` `^O` `^T`) live · no tmux `bind -n` key swallowing a zsh/nvim key · exceptions in `scripts/smoke/allow.txt` |

**PR autofix** (`.github/workflows/pr-autofix.yml`, on PRs touching config): bootstraps a clean macOS runner with `setup.sh --no-brew`, runs `smoke.py`; if red, Claude fixes the config (`fix: resolve smoke-check failures`). Then Claude syncs `docs/` to the diff (`docs: sync with config changes`), pushes, re-runs lint, and the job ends with `smoke.py` + `docs-check.py` (must be green). Allow-list and `scripts/` are never bot-edited. **Pull before continuing work on the branch.** One-time setup: `claude setup-token`, then `gh secret set CLAUDE_CODE_OAUTH_TOKEN`.

Clean-room: see [INSTALL.md](INSTALL.md#clean-room-test).
