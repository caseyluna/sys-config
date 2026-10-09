# Testing

Two scripts; no unit tests (config is declarative — "does it parse/load?" and "is the machine wired up?").

| Script | When | Checks |
|---|---|---|
| `bash scripts/lint.sh` | before commit; CI on every push/PR | `zsh -n` on zsh files · `bash -n` + `shellcheck` on scripts · tmux config parses on a private socket · Neovim config loads headless from the repo (`XDG_CONFIG_HOME`) · `stylua --check` on Lua · `jq` on JSON |
| `bash scripts/validate.sh` | after `setup.sh` or after pulling | every symlink from INSTALL.md points into the repo · required tools on PATH · `bat`/`delta` execute · git identity + pager · TPM + plugins present · headless `checkhealth` has no ERROR |

CI: `.github/workflows/lint.yml` runs `lint.sh` on `ubuntu-latest` for pushes to `main`/`dev` and all PRs.

Clean-room: see [INSTALL.md](INSTALL.md#clean-room-test).
