# Neovim keys

Leader is `<Space>`. Press `<Space>` and pause — which-key lists every group. `<Space>?` shows buffer-local keys, `<Space>fk` searches all keymaps. Source of truth: each file in `nvim/lua/cluna/plugins/` (banner comment) and `nvim/lua/cluna/core/keymaps.lua`.

## Groups at a glance

| Prefix | Group | Prefix | Group |
|---|---|---|---|
| `<Space>a` | harpoon | `<Space>q` | session |
| `<Space>b` | buffer | `<Space>r` | rename / outline |
| `<Space>c` | Claude | `<Space>s` | splits |
| `<Space>d` | debug | `<Space>S` | search & replace |
| `<Space>e` | explorer | `<Space>t` | tabs / terminal |
| `<Space>f` | find | `<Space>T` | tests |
| `<Space>g` | git | `<Space>u` | ui / undo |
| `<Space>h` | hunks | `<Space>x` | trouble |
| `<Space>l` | lazygit | `<Space>i` `<Space>p` | octo issue / PR (in octo buffers) |
| `<Space>m` | format / lint | `[` `]` | prev / next |

## Navigation

| I want to… | Keys | Plugin |
|---|---|---|
| Open a file by name | `<Space>ff` | telescope |
| Recent files / open buffers | `<Space>fr` / `<Space>fb` | telescope |
| Grep the project / word under cursor | `<Space>fs` / `<Space>fc` | telescope |
| Files changed in git | `<Space>fg` | telescope |
| Switch project | `<Space>fp` | telescope-project |
| Help / keymaps | `<Space>fh` / `<Space>fk` | telescope |
| Go to definition / implementation / type / references | `gd` `gi` `gt` `gR` | lsp |
| Hover docs | `K` | lsp |
| Symbol outline sidebar / fuzzy symbol search | `<Space>ra` / `<Space>rA` | aerial |
| Jump to any visible spot | `<Space>j` then label | flash |
| Pin file / open pins / jump to pin 1-4 | `<Space>a` / `<Space>am` / `<Space>1..4` | harpoon |
| File tree (float) / git status tree / buffer tree | `<Space>ee` / `<Space>eg` / `<Space>bf` | neo-tree |
| Edit a directory like a buffer | `<Space>o` (`-` = up) | oil |
| Next / prev buffer | `]b` / `[b` | bufferline |
| Close buffer (keep layout) / close others / pin | `<Space>bd` / `<Space>bo` / `<Space>bp` | snacks, bufferline |
| Move between splits **and tmux panes** | `Ctrl-h/j/k/l` | nvim-tmux-navigation |
| Next / prev function, class | `]f` `[f` `]c` `[c` | treesitter-textobjects |
| Expand / shrink selection by syntax | `Ctrl-Space` / `Backspace` (visual) | treesitter |
| Jumplist back / forward | `Ctrl-o` / `Ctrl-i` | vim |

## Editing

| I want to… | Keys | Plugin |
|---|---|---|
| Exit insert mode | `jk` | core |
| Complete: next / prev / accept / dismiss / docs | `Ctrl-j` `Ctrl-k` `Enter` `Ctrl-e` `Ctrl-Space` | blink.cmp |
| Scroll completion docs | `Ctrl-b` / `Ctrl-f` | blink.cmp |
| Snippet: jump forward / back | `Tab` / `S-Tab` (while a snippet is active) | blink.cmp |
| Rename symbol (live preview) | `<Space>rn` | inc-rename |
| Code action (fix, import, …) | `<Space>ca` | lsp |
| Format buffer / selection | `<Space>mp` | conform (also on save) |
| Lint now | `<Space>ml` | nvim-lint (also on save) |
| Toggle inlay hints | `<Space>uh` | lsp |
| Project find & replace / word under cursor / this file | `<Space>S` / `<Space>Sw` / `<Space>Sf` | spectre |
| Comment line / block / motion | `gcc` / `gbc` / `gc{motion}` | Comment |
| Surround add / change / delete | `ys{motion}{char}` / `cs{old}{new}` / `ds{char}` | nvim-surround |
| Select around/inside function, class, block | `af` `if` `ac` `ic` `ab` `ib` | treesitter-textobjects |
| Undo tree | `<Space>uu` | undotree |
| Increment / decrement number | `<Space>+` / `<Space>-` | core |
| Clear search highlight | `<Space>nh` | core |
| Next / prev TODO comment | `]t` / `[t` | todo-comments |

## Diagnostics & problems

| I want to… | Keys | Plugin |
|---|---|---|
| Show diagnostics for this line | `gl` | lsp |
| Next / prev diagnostic | `]d` / `[d` | lsp |
| Project diagnostics panel / this buffer | `<Space>xx` / `<Space>xd` | trouble |
| Quickfix / loclist / todos / LSP refs panel | `<Space>xq` `<Space>xl` `<Space>xt` `<Space>xr` | trouble |
| Restart LSP | `<Space>rs` | lsp |

## Git

| I want to… | Keys | Plugin |
|---|---|---|
| Lazygit (repo) / current file / config | `<Space>lg` / `<Space>lG` / `<Space>lC` | lazygit |
| Diff working tree vs HEAD / close | `<Space>gd` / `<Space>gc` | diffview |
| File history / repo history | `<Space>gh` / `<Space>gH` | diffview |
| Next / prev hunk | `]h` / `[h` | gitsigns |
| Stage / reset hunk (n or visual) | `<Space>hs` / `<Space>hr` | gitsigns |
| Stage / reset buffer, undo stage | `<Space>hS` / `<Space>hR` / `<Space>hu` | gitsigns |
| Preview hunk / diff this / diff vs ~ | `<Space>hp` / `<Space>hd` / `<Space>hD` | gitsigns |
| Blame line / toggle blame column | `<Space>hb` / `<Space>hB` | gitsigns |
| Select hunk text object | `ih` | gitsigns |
| GitHub: PR list / issue list / start review | `<Space>go` / `<Space>gi` / `<Space>gR` | octo |
| In a PR buffer: checkout, merge, squash-merge, commits, files, diff | `<Space>po pm pM pc pf pd` | octo |
| In a PR buffer: add/remove reviewer, close, reopen, URL, browser | `<Space>pv pV px pO pu pb` | octo |
| In an issue buffer: close, reopen, list, assignee, label, URL, browser | `<Space>ix io il ia iL iu ib` | octo |
| Review thread: comment, suggestion, delete, submit, approve, request changes, close | `<Space>ca sa cd vs va vr vx` | octo |

## Debug (nvim-dap, Python)

| Keys | Action |
|---|---|
| `<Space>db` / `<Space>dB` | toggle breakpoint / conditional breakpoint |
| `<Space>dc` | continue / start (choose "Launch file", "…with args", or "pytest: current file") |
| `<Space>dn` `<Space>di` `<Space>do` | step over / into / out |
| `<Space>de` | evaluate expression (normal or visual) |
| `<Space>dr` / `<Space>du` | REPL / toggle UI |
| `<Space>dl` / `<Space>dx` | run last / terminate |

Repo `.vscode/launch.json` configs are loaded automatically.

## Tests (neotest, pytest)

| Keys | Action |
|---|---|
| `<Space>Tr` / `<Space>TT` | run nearest / run file |
| `<Space>Td` | debug nearest (dap) |
| `<Space>Ts` / `<Space>To` / `<Space>TO` | summary / output / output panel |
| `<Space>Tx` | stop |

## Windows, tabs, terminal, sessions

| I want to… | Keys |
|---|---|
| Split vertical / horizontal / equalize / close | `<Space>sv` `<Space>sh` `<Space>se` `<Space>sx` |
| Maximize / restore current split | `<Space>sm` |
| Center buffer (no-neck-pain) | `<Space>z` |
| New / close / next / prev tab, buffer in new tab | `<Space>to` `<Space>tx` `<Space>tn` `<Space>tp` `<Space>tf` |
| Floating terminal | `<Space>tt` |
| Session: restore cwd / last / pick / don't save on exit | `<Space>qs` `<Space>ql` `<Space>qS` `<Space>qd` |

## Claude Code (claudecode.nvim)

| Keys | Action |
|---|---|
| `<Space>cc` / `<Space>cf` | toggle / focus Claude panel |
| `Alt-w` or `<Space>cw` | switch editor ↔ Claude (works from the terminal too) |
| `<Space>cb` | add current buffer as context |
| `<Space>cs` (visual) | send selection; in neo-tree/oil: add file |
| `<Space>cA` / `<Space>cd` | accept / deny Claude's diff |
| `<Space>cr` / `<Space>cC` / `<Space>cm` | resume / continue / pick model |

## Dashboard (start screen)

`n` new file · `e` explorer · `f` find file · `F` git files · `w` grep · `r` recent · `b` branches · `g` lazygit · `s` restore session · `t` todos · `p` plugins · `c` config · `q` quit
