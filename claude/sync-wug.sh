#!/usr/bin/env bash
# Regenerate GEMINI.md and AGENTS.md from claude/CLAUDE.md (canonical WUG).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/claude/CLAUDE.md"

sync_one() {
    local name="$1" dest="$2" title="$3"
    sed -e "s/Jaz/$name/g" -e "1s/.*/# $title - AI Development Partnership/" "$SRC" > "$dest"
}

sync_one "Ana" "$HOME/.gemini/GEMINI.md" "GEMINI.md"
sync_one "Fia" "$HOME/.config/opencode/AGENTS.md" "AGENTS.md"

echo "Synced -> Ana ($HOME/.gemini/GEMINI.md), Fia ($HOME/.config/opencode/AGENTS.md)"
