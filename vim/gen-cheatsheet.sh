#!/bin/bash

# Generate the vim cheatsheet: the vimcheatsheet.com poster plus a
# sidebar of custom bindings read from vimrc, so it can't drift from
# the real mappings. Output keeps its slot in the Warp-H rotation.
# Rerun after any vimrc mapping change.
#
# vimrc convention: a '" == name ==' line starts a section, and a
# plain '"' comment directly above a map or command! line is its
# label. Unlabeled lines (like a mode twin) and <Nop> maps are skipped.

SRC="$HOME/dotfiles/vimrc"
POSTER="$HOME/fileboxes/filed/cheatsheets-src/vim-poster.png"
OUT="$HOME/fileboxes/filed/cheatsheets/1-vim-cheatsheet.png"
RENDER="$(dirname "$0")/render-sidebar.swift"

# one "Section<TAB>Key<TAB>Label" line per labeled mapping
labeled_mappings() {
    awk '
        function pretty(k) {
            gsub(/<[Ll]eader>/, "-", k)
            gsub(/<CR>/, "Enter", k)
            gsub(/<S-Tab>/, "S-Tab", k)
            gsub(/<Tab>/, "Tab", k)
            while (match(k, /<C-.>/))
                k = substr(k, 1, RSTART - 1) "^" substr(k, RSTART + 3, 1) \
                    substr(k, RSTART + RLENGTH)
            gsub(/[<>]/, "", k)
            return k
        }
        { line = $0; sub(/^[ \t]+/, "", line) }
        line ~ /^" == .* ==$/ {
            section = line; gsub(/^" == | ==$/, "", section)
            label = ""; next
        }
        line ~ /^"/ { label = line; sub(/^" */, "", label); next }
        line ~ /^[nvixsoc]?(nore)?map[ \t]/ && label != "" && section != "" {
            if (line !~ /<Nop>/) {
                split(line, f, /[ \t]+/); i = 2
                while (f[i] ~ /^<(silent|buffer|expr|nowait|unique)>$/) i++
                print section "\t" pretty(f[i]) "\t" label
            }
        }
        line ~ /^command!?[ \t]/ && label != "" && section != "" {
            split(line, f, /[ \t]+/); i = 2
            while (f[i] ~ /^-/) i++
            print section "\t:" f[i] "\t" label
        }
        { label = "" }
    ' "$SRC"
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

labeled_mappings > "$TMP/keys.tsv"
swift "$RENDER" "$TMP/keys.tsv" "$POSTER" "$OUT"
