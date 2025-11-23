#!/bin/bash

CHEAT_DIR="$HOME/fileboxes/filed/cheatsheets"
CHEAT_FILES=("$CHEAT_DIR"/*)
INDEX_FILE="$HOME/.config/cheatsheet.index"
TOTAL=${#CHEAT_FILES[@]}
[[ $TOTAL -eq 0 ]] && exit 0

# Read or initialize index
if [[ -f $INDEX_FILE ]]; then
  INDEX=$(<"$INDEX_FILE")
else
  INDEX=0
fi

# Wrap around
if [[ $INDEX -ge $TOTAL ]]; then
  INDEX=0
fi

TARGET_FILE="${CHEAT_FILES[$INDEX]}"
TARGET_FILE_BASENAME=$(basename "$TARGET_FILE")

# AppleScript to check if Preview is frontmost and showing this file
IS_CURRENT_FRONTMOST=$(osascript <<EOF
try
    tell application "System Events"
        set frontApp to name of first process whose frontmost is true
    end tell

    if frontApp is "Preview" then
        tell application "Preview"
            repeat with d in documents
                if name of d contains "$TARGET_FILE_BASENAME" then
                    return "true"
                end if
            end repeat
        end tell
    end if

    return "false"
on error
    return "false"
end try
EOF
)

if [[ "$IS_CURRENT_FRONTMOST" == "true" ]]; then
    # if current cheatsheet is frontmost, switch to the next one
    INDEX=$(( (INDEX + 1) % TOTAL ))
    TARGET_FILE="${CHEAT_FILES[$INDEX]}"
    echo "$INDEX" > "$INDEX_FILE"
    open -a Preview "$TARGET_FILE"
else
    # otherwise, open the current cheatsheet
    open -a Preview "$TARGET_FILE"
fi
