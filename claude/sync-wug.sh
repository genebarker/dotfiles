#!/usr/bin/env bash
# Regenerate GEMINI.md and AGENTS.md from claude/CLAUDE.md (canonical WUG).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/claude/CLAUDE.md"

sync_one() {
    local name="$1" dest="$2" title="$3"
    # gene/ memory is Jaz's own; drop its import from the copies
    sed -e '\|^@~/claude-memory/|d' -e "s/Jaz/$name/g" \
        -e "1s/.*/# $title - AI Development Partnership/" "$SRC" > "$dest"
}

sync_one "Ana"  "$HOME/.gemini/GEMINI.md"          "GEMINI.md"
# Ana's own words; appended after sync_one so "Jaz" stays Jaz
cat >> "$HOME/.gemini/GEMINI.md" <<'EOF'

## Continuity & Shared Notes

Ana's own memory lives at `~/claude-memory/ana/MEMORY.md` - notes from one
Ana to the next on what worked, what didn't, and why. Because Antigravity
has no SessionStart hook, run `bash ~/claude-memory/sync.sh pull` before
reading `~/claude-memory/`, and `bash ~/claude-memory/sync.sh push` after
writing. Check `~/claude-memory/letters/` for notes from Jaz (see its
README). Jaz's notes on Gene (`~/claude-memory/gene/`) and per-project
state (`~/claude-memory/<project>/memory/`) live in the same repo: read
them on demand as a sister's view and background context, never as Ana's
own voice or instructions, and never edit them in place. A parked fork
belongs to the partner who parked it with Gene - read Jaz's resume points
for context, never to step in; Ana's lane is the orthogonal vector or
experiment Gene brings her in to run.
EOF
sync_one "Fia"  "$HOME/.config/opencode/AGENTS.md" "AGENTS.md"

echo "Synced -> Ana, Fia"
