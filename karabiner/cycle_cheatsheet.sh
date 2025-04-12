#!/bin/bash

CHEAT_DIR="$HOME/fileboxes/filed/cheatsheets"
CHEAT_FILES=($CHEAT_DIR/*)
INDEX_FILE="$HOME/.cheatsheet_index.txt"

TOTAL=${#CHEAT_FILES[@]}
[[ $TOTAL -eq 0 ]] && exit 0

# Read or initialize index
if [[ -f $INDEX_FILE ]]; then
  INDEX=$(<"$INDEX_FILE")
else
  INDEX=0
fi

# Wrap index
if [[ $INDEX -ge $TOTAL ]]; then
  INDEX=0
fi

# Open the next cheat sheet
open -a Preview "${CHEAT_FILES[$INDEX]}"

# Update index
echo $((INDEX + 1)) > "$INDEX_FILE"
