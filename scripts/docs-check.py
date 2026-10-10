#!/usr/bin/env python3
# ------------------------------------------------------------------------------
# docs-check.py — Fail if a keymap, alias or function is missing from the docs
# ------------------------------------------------------------------------------
# Checks (names only — whether descriptions are still accurate is left to the
# docs-sync workflow / a human):
#   <leader> keys in nvim/lua/**       → docs/KEYS.md
#   aliases in zsh/aliases.shrc        → docs/CHEATSHEET.md
#   functions in zsh/functions.shrc    → docs/CHEATSHEET.md
# KEYS.md compact forms are understood: `<Space>po pm pM` and `<Space>1..4`.
# Intentionally undocumented names go in docs/.docs-ignore (one per line, #
# comments). Names starting with `_` or `log_` are treated as internal.
# Usage: python3 scripts/docs-check.py   → exit 0 all documented, 1 otherwise
# Runs in CI (.github/workflows/lint.yml, docs-sync.yml); stdlib only.
# ------------------------------------------------------------------------------

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DOCS = REPO / "docs"


def ignored() -> set[str]:
    f = DOCS / ".docs-ignore"
    if not f.exists():
        return set()
    lines = (ln.split("#", 1)[0].strip() for ln in f.read_text().splitlines())
    return {ln for ln in lines if ln}


def leader_keys() -> dict[str, str]:
    """<leader> mappings in the nvim config → {"<Space>xx": "file"}."""
    keys: dict[str, str] = {}
    pat = re.compile(r"""["']<leader>([^"'\s]+)["']""")
    for f in sorted((REPO / "nvim/lua").rglob("*.lua")):
        for line in f.read_text().splitlines():
            if line.lstrip().startswith("--"):
                continue
            for m in pat.finditer(line):
                keys.setdefault("<Space>" + m.group(1), str(f.relative_to(REPO)))
    return keys


def documented_keys(text: str) -> set[str]:
    """Every <Space>… key written in KEYS.md, expanding compact forms."""
    found: set[str] = set()
    for span in re.findall(r"`([^`]+)`", text):
        in_space = False
        for tok in re.split(r"[\s/]+", span):
            if tok.startswith("<Space>"):
                in_space = True
                rng = re.fullmatch(r"<Space>(\d)\.\.(\d)", tok)
                if rng:
                    lo, hi = int(rng.group(1)), int(rng.group(2))
                    found |= {f"<Space>{n}" for n in range(lo, hi + 1)}
                else:
                    found.add(tok)
            elif in_space and re.fullmatch(r"[A-Za-z0-9]{1,4}", tok):
                found.add("<Space>" + tok)  # `<Space>po pm pM` → <Space>pm …
    return found


def shell_names() -> dict[str, str]:
    """Aliases and functions → {"name": "file"}."""
    names: dict[str, str] = {}
    alias = re.compile(r"^alias\s+([\w.-]+)=", re.MULTILINE)
    func = re.compile(r"^(?:function\s+)?([A-Za-z][\w-]*)\s*\(\)", re.MULTILINE)
    for f, pat in (("zsh/aliases.shrc", alias), ("zsh/functions.shrc", func)):
        for name in pat.findall((REPO / f).read_text()):
            if not name.startswith(("_", "log_")):
                names.setdefault(name, f)
    return names


def main() -> int:
    skip = ignored()
    missing: list[str] = []

    keys_doc = documented_keys((DOCS / "KEYS.md").read_text())
    for key, src in leader_keys().items():
        if key not in keys_doc and key not in skip:
            missing.append(f"docs/KEYS.md       {key:<14} ({src})")

    cheat = (DOCS / "CHEATSHEET.md").read_text()
    for name, src in shell_names().items():
        if name in skip:
            continue
        if not re.search(rf"(?<![\w-]){re.escape(name)}(?![\w-])", cheat):
            missing.append(f"docs/CHEATSHEET.md {name:<14} ({src})")

    if missing:
        print("[docs-check] Undocumented (add to the doc, or to docs/.docs-ignore):")
        print("\n".join(f"[docs-check]   {m}" for m in missing))
        return 1
    print("[docs-check] All keymaps, aliases and functions are documented.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
