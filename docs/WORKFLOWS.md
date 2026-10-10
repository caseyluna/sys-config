# Workflows

Task-based guide for common developer workflows using the full stack of tools in this config. Each section shows the fastest path through a task using the right tool for the job.

---

## Starting a session

### Fresh machine, new project
1. `tmux-sessionizer` — pick project directory → creates a named session
2. Neovim opens automatically with `<Space>qs` to restore last session if one exists
3. `<Space>ff` to find files, or `e` on the dashboard to open the file tree; `s` restores the last session

### Returning to work
1. `ta [name]` (attach-or-create) or `prefix + s` to pick a session
2. Persistence auto-restores your layout: buffers, splits, cursor positions per cwd
3. If Claude was open: `<Space>cr` to resume the last session

---

## Code navigation

### Finding anything fast
| Situation | Tool | Key |
|-----------|------|-----|
| Know the filename | Telescope find files | `<Space>ff` |
| Know a string in the code | Telescope live grep | `<Space>fs` |
| Want the word under cursor | Telescope word search | `<Space>fc` |
| Know the function/class name | Aerial symbol search | `<Space>rA` |
| Recent files | Telescope oldfiles | `<Space>fr` |
| Jump to a visible position | Flash labels | `<Space>j` |
| Pin 4 key files for a task | Harpoon | `<Space>aa` to add, `<Space>1–4` to jump |

### Navigating a codebase you don't know
1. `<Space>fs` live grep to find entry points
2. `gd` on a function call to follow definitions (LSP)
3. `gR` to see all references to a symbol
4. `<Space>ra` to open the aerial outline sidebar — scan the file's structure
5. `gt` to jump to the type definition
6. `K` on anything to read hover docs without leaving the file

---

## Git workflow

### Day-to-day git (LazyGit — recommended)
`<Space>lg` opens LazyGit. From there:
- `Space` to stage/unstage files
- `c` to commit
- `P` to push
- `p` to pull
- `b` to manage branches
- `r` on a branch to rebase interactively
- `q` to close

### Reviewing your own changes before committing
1. `<Space>gd` — diffview opens a full split diff vs HEAD; navigate files in the left panel
2. `<Space>hs` to stage individual hunks directly in Neovim, or stage whole file with `<Space>hS`
3. `<Space>hp` previews the hunk under the cursor; `<Space>hd` diffs the file against the index

### Reviewing someone else's PR
0. From the shell: `gprco` fuzzy-checks-out a PR; `gprv` opens it in the browser
1. `<Space>go` — Octo opens a PR list; pick one
2. `<Space>pf` to see changed files, `<Space>pd` to see the diff
3. `<Space>gR` to start a formal review
4. In review threads: `<Space>ca` to add a comment, `<Space>va` to approve, `<Space>vr` to request changes, `<Space>vs` to submit

### Exploring history
| What | Key |
|------|-----|
| Full repo history with diffs | `<Space>gH` (diffview repo history) |
| One file's history | `<Space>gh` (diffview file history) |
| Blame current line | `<Space>hb` |
| Toggle blame column | `<Space>hB` |

### Fixing a merge conflict
1. `<Space>gd` to open diffview — it detects conflicts automatically
2. Diffview shows the 3-way merge layout: ours | result | theirs
3. Edit the result buffer to resolve
4. `<Space>gc` to close diffview when done
5. Stage the resolved file: `<Space>hS`

### Interactive rebase
- From the shell: `grbi 5` (last 5 commits) — opens the todo list in nvim
- From LazyGit: `<Space>lg` (or `prefix + g` in tmux) → commits list → `e` for interactive rebase
- Full guide: [GIT-REBASE.md](GIT-REBASE.md)

---

## Editing workflows

### Project-wide find & replace
1. `<Space>SS` opens Spectre
2. Type search pattern, tab to replacement
3. `<Space>Sw` with cursor on a word to pre-fill the search
4. Apply per-match, per-file, or all at once inside the Spectre buffer

### Refactoring code
1. `<Space>rn` to rename a symbol across the whole project (LSP, live preview)
2. `<Space>ca` on a symbol for code actions — ruff offers import fixes/organize, pyright offers extract/inline where supported
3. `gR` to verify all references updated correctly

### Working with multiple files
1. `<Space>aa` to add up to 4 core files to Harpoon; `<Space>1–4` to jump instantly
2. `]b` / `[b` cycle open buffers; `<Space>bd` closes one without disturbing the layout
3. `<Space>Sf` to search/replace only within the current file

### Undo history
- `<Space>uu` opens undotree — a visual tree of every edit state
- Navigate with `j/k`, press Enter to jump to that state
- Undo branches are preserved even after redoing, unlike linear undo

---

## Debugging

### Python
1. debugpy is installed by Mason automatically (mason.lua)
2. Open a Python file, `<Space>db` to set a breakpoint on the line you want to pause at
3. `<Space>dc` to start — pick "Launch file" or "Launch file with args"
4. DAP UI opens automatically: scopes on the left, REPL at the bottom
5. `<Space>dn` step over, `<Space>di` step into, `<Space>do` step out
6. `<Space>de` on any variable to evaluate its current value
7. `<Space>dx` to terminate; `<Space>du` to close the UI panels

> If the session ends with an error, the UI stays open so you can inspect state. `<Space>du` to close manually.

### Debugging a specific test
1. Put the cursor on the test function
2. `<Space>Td` — Neotest runs the test with DAP attached
3. Breakpoints you set with `<Space>db` will be hit

---

## Testing

### Running tests
| What | Key |
|------|-----|
| Run test under cursor | `<Space>Tr` |
| Run entire file | `<Space>TT` |
| See all results | `<Space>Ts` (summary panel) |
| Read output / error for a test | `<Space>To` |
| Stop running | `<Space>Tx` |

### Test workflow
1. Write your test, put cursor inside the function
2. `<Space>Tr` to run it immediately
3. Green ✓ or red ✗ appears in the gutter inline
4. On failure: `<Space>To` to read the full output/traceback
5. `<Space>Ts` to see all tests in the summary panel and jump to failures

**Supported frameworks:** pytest (add adapters in `neotest.lua` for others)

---

## Session management

### Automatic session save
Persistence saves your session (buffers, layout, cursor) when you quit, keyed by cwd. Next time you `nvim` in the same directory it's all there.

| Key | Action |
|-----|--------|
| `<Space>qs` | Restore session for current directory |
| `<Space>ql` | Restore last session (any directory) |
| `<Space>qS` | Pick a session |
| `<Space>qd` | Quit this time without saving |

### tmux-sessionizer
`prefix + f` opens an fzf picker over your project directories. Selecting one:
- Creates a new tmux session named after the directory if it doesn't exist
- Attaches if it does

Run directly: `tmux-sessionizer ~/projects/foo`, or `ts` from the shell. Project roots: `TMUX_PROJECT_DIRS="dir1:dir2"`

---

## Working with Claude Code

### From the shell
- `cc` / `ccc` / `ccr` — new / continue / resume. `ccd <branch>` creates a git worktree for the branch and starts Claude in it (parallel work on two branches).
- `dev` — tmux layout with nvim (top-left), shell (bottom-left), Claude (right).
- Hooks (`claude/hooks/`): every file Claude edits is auto-formatted (stylua/ruff/shfmt/prettier/terraform/taplo); a macOS notification fires when Claude needs input.
- Skills: `/dotfiles-check`, `/nvim-plugin`, `/brew-audit`, `/stack-rebase` (`claude/skills/`).

### In Neovim (claudecode.nvim)
- `<Space>cc` to toggle the panel; `Alt-w` to switch focus between editor and Claude
- `<Space>cb` to add the current buffer as context
- Visual select + `<Space>cs` to send a specific selection

### Inline diff workflow
1. Ask Claude to make a change
2. Claude writes the diff directly into the buffer
3. Review it, then `<Space>cA` to accept or `<Space>cd` to deny

### Tips
- Use `<Space>cr` to resume a previous conversation with full context
- Open multiple files in splits and use `<Space>cb` on each to give Claude more context
- `<Space>cm` to switch models mid-conversation

---

## Config & tools maintenance

> See [UPDATING.md](UPDATING.md) for the full guide on updating plugins, adding new ones, and managing this config.

### Quick tasks
| Task | How |
|------|-----|
| Install a new LSP server or formatter | `:Mason` → search → `i` to install |
| Update all Neovim plugins | `:Lazy update` |
| Update all shell/system tools | `brewup` |
| Check what's broken | `bash scripts/lint.sh` |
| Verify symlinks after pulling | `bash scripts/validate.sh` |
| Reload tmux config without restart | `prefix + r` |
| Reload shell config | `sz` (alias for `source ~/.zshrc`) |
