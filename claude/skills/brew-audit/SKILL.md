---
name: brew-audit
description: Audit Homebrew against the sys-config Brewfile — deprecated or disabled formulae, packages installed but not declared, declared but missing, and brew doctor warnings.
---

# brew-audit

All steps read-only unless the user asks to apply.

1. `brew doctor` — note warnings about deprecated/disabled casks or formulae.
2. `brew bundle check --file="$SYS_CONFIG/Brewfile" --verbose` — declared but not installed.
3. `brew bundle cleanup --file="$SYS_CONFIG/Brewfile"` (dry run, no `--force`) — installed but not declared.
4. For each formula in the Brewfile that looks suspicious, `brew info <name>` and flag `deprecated`/`disabled` lines.
5. `brew outdated` — upgrades available.

Output three lists — **remove from Brewfile**, **add to Brewfile**, **upgrade** — each line with a one-phrase reason. Keep the Brewfile's section comments when proposing edits.
