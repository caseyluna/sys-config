# Cheatsheet — shell & tmux

Neovim keys are in [KEYS.md](KEYS.md).

## Zsh key bindings

| Key | Action | From |
|---|---|---|
| `Ctrl-R` | history search TUI (per-dir filter with `Ctrl-R` again) | atuin |
| `Ctrl-T` / `Ctrl-E` | fuzzy pick file(s) → insert path (Tab = multi) | fzf |
| `Alt-C` | fuzzy cd | fzf |
| `Ctrl-O` | launcher: files / directories / history | fzf/launcher-widget |
| `Tab` | fzf-powered completion (`,` `.` switch groups) | fzf-tab |
| `→` / `End` | accept autosuggestion | zsh-autosuggestions |
| `z foo` / `zi` | jump to frecent dir / interactive | zoxide |

## Aliases (`zsh/aliases.shrc`)

**Shell** `c` clear · `xx` exit · `rsh` restart shell · `sz` reload config · `cdh` home · `cdc` this repo · `path` PATH one-per-line · `cpwd` copy cwd · `ll` `la` · `cat`→bat · `dusort` biggest items

**Editor / tmux** `vim` `vv`→nvim · `dev` nvim+shell+claude tmux layout · `ts` project session picker · `tl` tmux ls

**Git** `g ga gst gd gdc gl glg gstack gb gco gcob gc gca gamend gundo gp gpf gpu gf gcl gra grr gsync glom gwt` · `gcpr` create PR · `gprv` view PR · `gprs` PR status · `lg` lazygit · `ld` lazydocker

**Python / uv** `python` `pip` → 3 · `uvv` venv+activate · `uvs` sync · `uva` add · `uvr` run · `uvp` install from pyproject · `uvclean` empty venv · `vd` deactivate · `pyt` pytest -x · `pytl` last failures

**Terraform** `tf` project wrapper · `tfi tfp tfa tfd tff tfv`

**Docker** `dkps dkpsa dkimgs dkst dkl dke dkclean dk-up dk-down dk-start dk-stop dk-clean`

**Kubernetes** `kgp kgj kjr kjf`

**direnv** `da` allow · `dr` reload

**Claude** `cc` claude · `ccc` continue · `ccr` resume

**System** `ports` · `ip` public IP (Linux's own: `command ip a`) · `devip` LAN IP · `flushdns` (macOS dscacheutil / Linux resolvectl) · `brewup` · `brewdiff` (installed but not in Brewfile)

**Work** `R` · `db-proxy-prod` · `db-cli-prod` · `ppp` (macOS keychain)

## Functions (`zsh/functions.shrc` — each has a `# USAGE:` line)

| Function | Does |
|---|---|
| `mkcd d` · `tmpd` · `groot` | mkdir+cd · cd to temp dir · cd to repo root |
| `rgf pat` | ripgrep → fzf (bat preview) → open in nvim at line |
| `extract f` | unpack any archive |
| `killport n` · `fkill` · `serve [port]` | kill by port · fuzzy kill · http.server |
| `gbf` · `grbi [n]` · `gbclean` · `gprco` · `gwta br` · `glogone [n]` | fuzzy branch switch · rebase -i last n · delete merged · fuzzy PR checkout · worktree add + cd · last n commits oneline |
| `ta [name]` · `tk` | tmux attach-or-create · fuzzy kill session |
| `va [dir]` · `pyclean` | activate venv · remove caches |
| `csvq f [sql]` · `pq f [sql]` · `jqf f` | duckdb over CSV / parquet (table `t`) · browse JSON paths |
| `tfw` | fuzzy terraform workspace |
| `dklf` · `dksh` · `kx` · `kns` · `kl` · `kex` | fuzzy container logs / shell · kube context / namespace / pod logs / pod shell |
| `ccd br` | worktree for branch + claude |
| `gcpp` · `query-gcp` · `bigquery` · `delete_branches` | gcloud / BigQuery helpers · interactive branch delete (see file) |
| `phil-db-up db…\|--all` · `phil-db-switch` · `phil-db-status` · `phil-db-down` | Cloud SQL proxy: start sockets · pick socket → mysql · show proxies · stop all |
| `pbcopy` · `pbpaste` · `open x…` | **Linux shims** (macOS has the real ones): clipboard via wl-copy / xclip / OSC 52 over SSH · `xdg-open` |

## Tasks (`Taskfile.yml`, go-task)

Run `task <name>` in the repo, or `task -g <name>` from anywhere. `task` alone lists them.

| Task | Does |
|---|---|
| `check` | lint + docs coverage + smoke — what CI runs; use before committing |
| `lint` · `docs` · `smoke` · `validate` | the individual checks (`task smoke -- nvim` for one tool) |
| `doctor` | validate + smoke + Brewfile check — "is this machine healthy?" |
| `update` | Homebrew + nvim plugins + Mason tools + tmux plugins, then smoke |
| `setup` · `links` · `clean-room` | bootstrap · re-link only · link into a throwaway `$HOME` |
| `setup:config` · `setup:server` | re-apply config without installs · headless Linux re-run (no prompts, no GUI apps) |
| `brew:check` · `brew:extra` · `brew:update` | missing/outdated · installed-but-undeclared (dry run) · install + upgrade |
| `nvim:update` · `nvim:health` | Lazy sync + Mason update · checkhealth errors/warnings only |
| `tmux:update` · `tmux:reload` | TPM install/update · reload config |
| `zsh:cache` | rebuild completion caches ("zwc file has wrong version") |

## tmux (prefix = `Ctrl-A`)

| Keys | Action |
|---|---|
| `prefix \|` / `prefix -` | split right / below (in current dir) |
| `prefix c` | new window (in current dir) |
| `prefix h j k l` | move between panes · `Ctrl-h/j/k/l` (no prefix) also crosses into nvim splits |
| `prefix H J K L` | resize (repeatable) |
| `prefix < >` | move window left / right |
| `prefix f` | project session picker popup (tmux-sessionizer) |
| `prefix g` | lazygit popup in current dir |
| `prefix F` | tmux-fzf: sessions / windows / panes |
| `prefix v` | copy mode → `v` select, `y` copy to clipboard, `Esc` cancel |
| `prefix d` / `prefix s` | detach / session list |
| `prefix Ctrl-s` / `prefix Ctrl-r` | save / restore session (resurrect; continuum autosaves every 15 min) |
| `prefix r` | reload config |
| `prefix I` / `prefix U` | install / update plugins |
| `prefix Ctrl-a` | send a literal Ctrl-A |

## Ghostty

`⌘D` split right · `⌘⇧D` split down · `⌘←→↑↓` move between splits · `⌘=` equalize. Font: JetBrainsMono Nerd Font. Theme: catppuccin-mocha.
Linux: `⌘` is the Super key (GNOME claims `Super+arrows` for tiling — rebind one side).
