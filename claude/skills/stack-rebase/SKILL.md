---
name: stack-rebase
description: Rebase a stack of dependent branches (S1 → S2 → S3 …) after the base moved, pushing each with --force-with-lease. Use when working the sys-config stacked-PR flow.
---

# stack-rebase

Arguments: the ordered list of branches, lowest first (e.g. `dev S1 S2 S3`). Default base is `dev`.

1. `git fetch --prune` and confirm the working tree is clean (`git status --short`). Stop if dirty.
2. For each branch `B[i]` with parent `B[i-1]`, in order:
   - `git switch B[i]`
   - `git rebase --onto B[i-1] $(git merge-base B[i] B[i-1]@{1} 2>/dev/null || echo B[i-1]) B[i]`
     — if the simple form `git rebase B[i-1]` is unambiguous (no duplicated commits), prefer it.
   - On conflict: show `git diff --name-only --diff-filter=U`, resolve with the user, `git rebase --continue`.
3. Only after every branch rebases cleanly: `git push --force-with-lease` for each branch, lowest first.
4. Print `git log --oneline --graph B[last] ^dev` as the final stack picture, and `gh pr status`.

Never use bare `--force`. Never rebase `main` or `dev` themselves.
