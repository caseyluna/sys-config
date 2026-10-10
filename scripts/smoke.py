#!/usr/bin/env python3
# ------------------------------------------------------------------------------
# smoke.py — "Will it work when I use it?" check for nvim, tmux and zsh
# ------------------------------------------------------------------------------
# Starts each tool for real (from this repo's config, with installed plugins)
# and fails on:
#   nvim  errors on startup / plugin load / opening a .py .sh .sql .tf .lua .md
#         an installed LSP server that doesn't attach to its filetype
#         two sources mapping the same global key (config, lazy `keys`, or a
#         plugin's default) · a mapping that is a prefix of another (<Space>g
#         vs <Space>gs: the shorter one only fires after timeoutlen)
#         deprecation warnings (reported, non-fatal)
#   tmux  errors sourcing tmux.conf · a key bound twice in tmux.conf · a plugin
#         rebinding a key tmux.conf sets · unresolved #{battery_*} in status-right
#   zsh   stderr from an interactive start · bindkey lines in zsh/ fzf/ that a
#         later plugin overrode · the bindings in ZSH_EXPECT below
#   cross tmux root-table keys (-n) that swallow a key zsh or nvim binds
# Intentional exceptions: scripts/smoke/allow.txt (one finding per line, as
# printed, e.g. `nvim: n <Space>x: ...`; prefix match, # comments).
# Usage: python3 scripts/smoke.py [nvim|tmux|zsh ...]  → exit 0 ok, 1 otherwise
# Needs: plugins installed (setup.sh), nvim ≥ 0.11, tmux, zsh. ~10s locally.
# Runs in CI via .github/workflows/pr-autofix.yml; stdlib only.
# ------------------------------------------------------------------------------

import json
import os
import pty
import re
import select
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from collections import defaultdict
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
HERE = REPO / "scripts" / "smoke"

# Bindings that come from tools (not bindkey lines in this repo) but that the
# docs promise — checked against the live interactive shell.
ZSH_EXPECT = {
    "^R": "atuin-search",  # atuin owns Ctrl-R (CLAUDE.md / CHEATSHEET.md)
    "^T": "fzf-file-widget",
    "^[c": "fzf-cd-widget",
}
# tmux root keys that are meant to be shared with nvim (vim-tmux-navigator).
NAVIGATOR_KEYS = {"C-h", "C-j", "C-k", "C-l", "C-\\"}
TMUX_ALIASES = {
    "display": "display-message",
    "send": "send-keys",
    "splitw": "split-window",
    "neww": "new-window",
}

errors: list[str] = []
warns: list[str] = []


def allowed() -> list[str]:
    f = HERE / "allow.txt"
    if not f.exists():
        return []
    lines = (ln.split("#", 1)[0].strip() for ln in f.read_text().splitlines())
    return [ln for ln in lines if ln]


def fail(msg: str) -> None:
    errors.append(msg)


def canon(key: str) -> str:
    """Normalize a key across tools: <C-H> / ^H / C-h → C-h, <M-x> / ^[x → M-x."""
    m = re.fullmatch(r"<([CM])-(.+)>", key, re.IGNORECASE)
    if m:
        return f"{m.group(1).upper()}-{m.group(2).lower()}"
    if re.fullmatch(r"\^\[.", key):
        return "M-" + key[2:]
    if re.fullmatch(r"\^.", key):
        return "C-" + key[1:].lower()
    return key


# ------------------------------------------------------------------------------
# nvim
# ------------------------------------------------------------------------------
def check_nvim() -> dict[str, set[str]]:
    """Returns global normal-mode maps {canon key: sources} for the cross check."""
    if not shutil.which("nvim"):
        fail("nvim: not installed")
        return {}
    tmp = Path(tempfile.mkdtemp())
    out = tmp / "nvim.json"
    # Private XDG_CONFIG_HOME with nvim → repo: tests the repo copy, and plugins
    # that write config (copilot auth etc.) can't land in the repo.
    (tmp / "config").mkdir()
    (tmp / "config/nvim").symlink_to(REPO / "nvim")
    env = os.environ | {
        "SMOKE_OUT": str(out),
        "SMOKE_REPO": str(REPO),
        "XDG_CONFIG_HOME": str(tmp / "config"),
    }
    try:
        subprocess.run(
            ["nvim", "--headless", "--cmd", f"luafile {HERE / 'nvim.lua'}"],
            env=env,
            capture_output=True,
            timeout=180,
            check=False,
        )
    except subprocess.TimeoutExpired:
        fail("nvim: probe timed out after 180s")
        return {}
    if not out.exists():
        fail("nvim: probe produced no result (config crashed before VimEnter?)")
        return {}
    data = json.loads(out.read_text())

    for e in data["errors"]:
        fail(f"nvim: error: {e}")
    for w in data["warns"]:
        warns.append(f"nvim: {w}")
    for lsp in data["lsp"]:
        for name in sorted(set(lsp["expected"]) - set(lsp["attached"])):
            fail(
                f"nvim: lsp: {name} is installed but did not attach to a .{lsp['ft']} buffer (see :LspLog)"
            )

    by_key: dict[tuple[str, str], set[str]] = defaultdict(set)
    for m in data["maps"]:
        by_key[(m["mode"], m["lhs"])].add(m["src"])
    for (mode, lhs), srcs in sorted(by_key.items()):
        # Same file defining it twice (e.g. on reload) isn't a conflict.
        files = {re.sub(r":\d+$", "", s) for s in srcs}
        if len(files) > 1:
            fail(f"nvim: {mode} {lhs}: mapped by {', '.join(sorted(srcs))}")

    # Prefix shadowing — only among this config's own <Space> maps; plugin
    # defaults like `gc`/`gcc` are designed that way.
    mine = {
        (mode, lhs)
        for (mode, lhs), s in by_key.items()
        if any(not x.startswith("plugin:") for x in s)
    }
    leader = sorted(k for k in mine if k[1].startswith("<Space>"))
    for mode, lhs in leader:
        longer = [
            x for m2, x in leader if m2 == mode and x != lhs and x.startswith(lhs)
        ]
        if longer:
            fail(
                f"nvim: {mode} {lhs}: is a prefix of {', '.join(longer[:3])} — {lhs} waits for timeoutlen"
            )

    return {canon(lhs): srcs for (mode, lhs), srcs in by_key.items() if mode == "n"}


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------
def tmux_conf_binds() -> list[tuple[str, str, str, int]]:
    """(table, key, command, line) for every bind in tmux.conf."""
    binds = []
    for n, line in enumerate((REPO / "tmux/.tmux.conf").read_text().splitlines(), 1):
        line = line.split(" #", 1)[0].strip()
        if not re.match(r"bind(-key)?\s", line):
            continue
        toks = shlex.split(line.replace("\\;", ";"), posix=True)[1:]
        table = "prefix"
        while toks and toks[0] in ("-n", "-r", "-T", "-N"):  # a bare `-` is a key
            flag = toks.pop(0)
            if flag == "-n":
                table = "root"
            elif flag in ("-T", "-N"):
                value = toks.pop(0)
                table = value if flag == "-T" else table
        if len(toks) >= 2:
            binds.append((table, toks[0], toks[1], n))
    return binds


def check_tmux() -> set[str]:
    """Returns root-table keys (canonical) for the cross check."""
    if not shutil.which("tmux"):
        fail("tmux: not installed")
        return set()
    sock = f"smoke-{os.getpid()}"
    tmp = tempfile.mkdtemp()

    def tmux(*args: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            ["tmux", "-L", sock, *args],
            capture_output=True,
            text=True,
            timeout=60,
            check=False,
        )

    root: set[str] = set()
    try:
        tmux("-f", "/dev/null", "new-session", "-d", "-x", "200", "-y", "50")
        # Keep resurrect/continuum away from the real saved sessions.
        tmux("set", "-g", "@resurrect-dir", tmp)
        r = tmux("source-file", str(REPO / "tmux/.tmux.conf"))
        for line in (r.stderr + r.stdout).splitlines():
            if line.strip():
                fail(f"tmux: config: {line.strip()}")
        time.sleep(1)  # let `run` plugin scripts finish

        seen: dict[tuple[str, str], int] = {}
        for table, key, cmd, n in tmux_conf_binds():
            if (table, key) in seen:
                fail(
                    f"tmux: {table} {key}: bound twice in tmux.conf (lines {seen[(table, key)]} and {n})"
                )
            seen[(table, key)] = n
            live = tmux("list-keys", "-T", table, key).stdout.split()
            # bind-key [-r] -T <table> <key> <command…>
            live_cmd = next(
                (w for i, w in enumerate(live) if i > 0 and live[i - 1] == key), ""
            )
            want = TMUX_ALIASES.get(cmd, cmd)
            if live_cmd and live_cmd != want and not live_cmd.startswith(want):
                fail(
                    f"tmux: {table} {key}: tmux.conf:{n} binds `{cmd}` but a plugin rebound it to `{live_cmd}`"
                )
            elif not live_cmd:
                fail(
                    f"tmux: {table} {key}: tmux.conf:{n} binding is missing after load"
                )

        status = tmux("show", "-gv", "status-right").stdout
        if (
            Path.home() / ".tmux/plugins/tmux-battery"
        ).is_dir() and "#{battery_" in status:
            fail(
                "tmux: status-right still has literal #{battery_*} — tmux-battery ran before status-right was set"
            )

        for line in tmux("list-keys", "-T", "root").stdout.splitlines():
            parts = line.split()
            key = parts[parts.index("root") + 1] if "root" in parts else ""
            if key and not key.startswith(
                ("Mouse", "Wheel", "Double", "Triple", "Secondclick")
            ):
                root.add(canon(key))
    finally:
        tmux("kill-server")
        shutil.rmtree(tmp, ignore_errors=True)
    return root


# ------------------------------------------------------------------------------
# zsh
# ------------------------------------------------------------------------------
def interactive_zsh(script: str, timeout: float = 30) -> tuple[str, str]:
    """Run `script` in a real interactive zsh on a pty (zle only exists on a tty)."""
    out_file = Path(tempfile.mkdtemp()) / "out"
    master, slave = pty.openpty()
    err_r, err_w = os.pipe()
    cmd = f"{script} > {shlex.quote(str(out_file))}; exit"
    proc = subprocess.Popen(
        ["zsh", "-i"], stdin=slave, stdout=slave, stderr=err_w, close_fds=True
    )
    os.close(slave)
    os.close(err_w)
    os.write(master, (cmd + "\n").encode())
    stderr, deadline = b"", time.time() + timeout
    while proc.poll() is None and time.time() < deadline:
        r, _, _ = select.select([master, err_r], [], [], 0.2)
        if master in r:
            try:
                os.read(master, 65536)  # drain the prompt so zsh never blocks
            except OSError:
                break
        if err_r in r:
            stderr += os.read(err_r, 65536)
    proc.kill() if proc.poll() is None else None
    os.close(master)
    os.close(err_r)
    out = out_file.read_text() if out_file.exists() else ""
    return out, stderr.decode(errors="replace")


def check_zsh() -> set[str]:
    """Returns emacs-keymap keys (canonical) for the cross check."""
    if not (Path.home() / ".zshrc").exists():
        fail("zsh: ~/.zshrc missing — run setup.sh --links-only")
        return set()
    out, err = interactive_zsh("bindkey -M emacs")
    noise = re.compile(
        r"^\s*$|\x1b|^%|compinit|insecure"
    )  # prompt escapes, compaudit chatter
    for line in err.splitlines():
        if not noise.search(line):
            fail(f"zsh: startup stderr: {line.strip()}")
    live = {}
    for line in out.splitlines():
        m = re.match(r'^"(.+)" (\S+)$', line.strip())
        if m:
            live[m.group(1)] = m.group(2)
    if not live:
        fail(
            "zsh: interactive shell produced no bindkey output (startup hung or crashed)"
        )
        return set()

    expect = dict(ZSH_EXPECT)
    for f in sorted([*(REPO / "zsh").glob("*"), *(REPO / "fzf").glob("*.zsh")]):
        for m in re.finditer(
            r"bindkey\s+(?:-M\s+emacs\s+)?'([^']+)'\s+(\S+)", f.read_text()
        ):
            expect[m.group(1)] = m.group(2)
    for key, widget in sorted(expect.items()):
        got = live.get(key)
        if got != widget:
            fail(
                f"zsh: {key}: expected `{widget}`, live binding is `{got or 'unbound'}`"
            )
    return {
        canon(k) for k, w in live.items() if w not in ("self-insert", "undefined-key")
    }


# ------------------------------------------------------------------------------
def main(argv: list[str]) -> int:
    which = set(argv) or {"nvim", "tmux", "zsh"}
    nvim_keys = check_nvim() if "nvim" in which else {}
    root = check_tmux() if "tmux" in which else set()
    zsh_keys = check_zsh() if "zsh" in which else set()

    for key in sorted(root - NAVIGATOR_KEYS):
        users = [
            n
            for n, keys in (("zsh", zsh_keys), ("nvim", set(nvim_keys)))
            if key in keys
        ]
        if users:
            fail(
                f"cross: tmux root key {key} (bind -n) swallows it before {' and '.join(users)} sees it"
            )

    allow = allowed()
    real = [e for e in errors if not any(e.startswith(a) for a in allow)]
    for w in warns:
        print(f"[smoke]   warn {w}")
    for e in real:
        print(f"[smoke]   FAIL {e}")
    if real:
        print(
            f"[smoke] {len(real)} problem(s). Fix, or add to scripts/smoke/allow.txt if intentional."
        )
        return 1
    print(f"[smoke] OK — {', '.join(sorted(which))} start clean, no key conflicts.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
