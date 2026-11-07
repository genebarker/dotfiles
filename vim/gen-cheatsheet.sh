#!/bin/bash

# Generate the vim cheatsheet: the vimcheatsheet.com poster plus a
# sidebar from the CHEATSHEET block in vimrc. Output keeps its slot
# in the Warp-H rotation. Rerun after editing the block.
#
# vimrc convention: the CHEATSHEET block at the top of vimrc is the
# sheet. It runs from its banner to the next '"---' line; inside, a
# '" == name ==' line starts a section and a '" <key> <label>' line
# is one row, key written as it should display. Curation, not
# scraping: no row in the block, nothing on the sheet.

SRC="$HOME/dotfiles/vimrc"
POSTER="$HOME/fileboxes/filed/cheatsheets-src/vim-poster.png"
OUT="$HOME/fileboxes/filed/cheatsheets/1-vim-cheatsheet.png"
RENDER="$(dirname "$0")/render-sidebar.swift"

# one "Section<TAB>Key<TAB>Label" line per row in the block
cheatsheet_rows() {
    awk '
        /^" CHEATSHEET/ { state = 1; next }
        state == 0 || /^[ \t]*$/ { next }
        /^"-+$/ { if (state == 2) exit; state = 2; next }
        /^" == .* ==$/ {
            section = $0; gsub(/^" == | ==$/, "", section); next
        }
        {
            line = $0; sub(/^" +/, "", line)
            key = line; sub(/[ \t].*/, "", key)
            label = line; sub(/^[^ \t]+[ \t]+/, "", label)
            print section "\t" key "\t" label
        }
    ' "$SRC"
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cheatsheet_rows > "$TMP/keys.tsv"
swift "$RENDER" "$TMP/keys.tsv" "$POSTER" "$OUT"
