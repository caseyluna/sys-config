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

**Git** `g ga gst gd gdc gl glg gstack gb gco gm gma gamend gundo gp gpf gpu gf gcl gra grr gsync glom gwt` · `gcpr` create PR · `gprv` view PR · `gprs` PR status · `lg` lazygit · `ld` lazydocker

**Python / uv** `python` `pip` → 3 · `uvv` venv+activate · `uvs` sync · `uva` add · `uvr` run · `uvp` install from pyproject · `uvclean` empty venv · `vd` deactivate · `pyt` pytest -x · `pytl` last failures

**Terraform** `tf` project wrapper · `tfi tfp tfa tfd tff tfv`

**Docker** `dkps dkpsa dkimgs dkst dkl dke dkclean dk-up dk-down dk-start dk-stop dk-clean`

**Kubernetes** `kgp kgj kjr kjf`

**Claude** `cc` claude · `ccc` continue · `ccr` resume

**System** `ports` · `ip` · `devip` · `flushdns` · `brewup` · `brewdiff` (installed but not in Brewfile)

**Work** `R` · `db-proxy-prod` · `db-cli-prod` · `ppp`

## Functions (`zsh/functions.shrc` — each has a `# USAGE:` line)

| Function | Does |
|---|---|
| `mkcd d` · `tmpd` · `groot` | mkdir+cd · cd to temp dir · cd to repo root |
| `rgf pat` | ripgrep → fzf (bat preview) → open in nvim at line |
| `extract f` | unpack any archive |
| `killport n` · `fkill` · `serve [port]` | kill by port · fuzzy kill · http.server |
| `gbf` · `grbi [n]` · `gbclean` · `gprco` · `gwta br` | fuzzy branch switch · rebase -i last n · delete merged · fuzzy PR checkout · worktree add + cd |
| `ta [name]` · `tk` | tmux attach-or-create · fuzzy kill session |
| `va [dir]` · `pyclean` | activate venv · remove caches |
| `csvq f [sql]` · `pq f [sql]` · `jqf f` | duckdb over CSV / parquet (table `t`) · browse JSON paths |
| `tfw` | fuzzy terraform workspace |
| `dklf` · `dksh` · `kx` · `kns` · `kl` · `kex` | fuzzy container logs / shell · kube context / namespace / pod logs / pod shell |
| `ccd br` | worktree for branch + claude |
| `gcpp` · `query-gcp` · `bigquery` · `delete_branches` · `phil-db-*` | gcloud / BigQuery / Cloud SQL helpers (see file) |

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
