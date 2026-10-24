#!/bin/bash

# Generate the Warp / Super / Ghost cheatsheet from karabiner.json rule
# descriptions, so it can't drift from the real bindings. Output lands
# first in the Warp-H rotation. Rerun after any karabiner.json change.

SRC="$HOME/dotfiles/karabiner/karabiner.json"
OUT="$HOME/fileboxes/filed/cheatsheets/0-karabiner.pdf"
COL_WIDTHS="58 49 36"  # Warp, Super, Ghost

# one "Layer<TAB>Key<TAB>Action" line per layer rule; drops the
# "(j = dvorak h)" physical-key notes and a leading "to "
layer_rules() {
    jq -r '.profiles[0].complex_modifications.rules[].description' "$SRC" |
    sed -nE 's/^(Warp|Super|Ghost)-([^ ]+) (\([^)]*\) )?(.*)$/\1\t\2 \3\t\4/p' |
    sed -E 's/ \([^)]*dvorak[^)]*\)//; s/\tto /\t/; s/ +\t/\t/'
}

column_for() {
    local title="$1" key="$2"
    printf '%s (%s)\n' "$(tr a-z A-Z <<< "$title")" "$key"
    printf '%s\n' "------------------------------"
    layer_rules | awk -F'\t' -v l="$title" '$1 == l { print $2 "\t" $3 }' |
        sort -f | awk -F'\t' '{ printf "%-9s %s\n", $1, $2 }'
}

# pad each column to its width and lay them side by side
side_by_side() {
    awk -v ws="$COL_WIDTHS" '
        BEGIN { split(ws, w, " ") }
        FNR == 1 { f++ }
        { line[f, FNR] = substr($0, 1, w[f] - 1); if (FNR > max) max = FNR }
        END {
            for (i = 1; i <= max; i++) {
                out = ""
                for (j = 1; j <= f; j++) {
                    cell = line[j, i]
                    out = out sprintf("%-" w[j] "s", cell)
                }
                sub(/ +$/, "", out); print out
            }
        }' "$@"
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

column_for Warp  "Caps held"    > "$TMP/1"
column_for Super "Tab held"     > "$TMP/2"
column_for Ghost "; or z held"  > "$TMP/3"

{
    side_by_side "$TMP/1" "$TMP/2" "$TMP/3"
    echo
    echo "Tap: Caps = Esc, Tab = Tab, ; z = themselves." \
        " Esc clears all layers.   Home row mods: GASC, both hands"
    echo "Generated $(date '+%Y-%m-%d') from karabiner.json by" \
        "gen-cheatsheet.sh"
} > "$TMP/sheet.txt"

cupsfilter -o landscape -o cpi=14 -o lpi=5 "$TMP/sheet.txt" \
    > "$OUT" 2> /dev/null
echo "Wrote $OUT"
