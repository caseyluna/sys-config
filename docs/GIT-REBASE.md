# Interactive rebase

Three ways, same result. All open the rebase todo in Neovim (`EDITOR=nvim`).

## From the shell

```bash
grbi 5            # git rebase -i HEAD~5
git rebase -i dev # everything since dev
```

## From lazygit (`lg`, `<Space>lg` in nvim, `prefix + g` in tmux)

Commits panel (`4`) → move to the commit to start from → `e` (edit) or `i` (interactive). Then on each commit: `s` squash, `f` fixup, `r` reword, `d` drop, `Ctrl-j/k` move. `m` → continue. `q` leaves.

## The todo list

```
pick   keep
reword change message
squash merge into previous, edit combined message
fixup  merge into previous, keep previous message
drop   delete
```

Reorder lines to reorder commits. `:wq` to run. Conflicts: fix the file, `git add`, `git rebase --continue`; bail with `git rebase --abort`. In Neovim, `<Space>gd` (diffview) shows conflicts in a 3-way layout.

## Stacked branches

Use the `/stack-rebase` Claude skill, or by hand: rebase each branch onto its parent lowest-first, then `gpf` (`push --force-with-lease`) each.
