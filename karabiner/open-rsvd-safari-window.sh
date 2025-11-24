#!/bin/bash

TARGET_HOST="$1"  # e.g. github.com or calendar.google.com

if ! pgrep -x "Safari" > /dev/null; then
    open -a "Safari" "https://$TARGET_HOST"
    exit
fi 

osascript <<EOF
set targetHost to "$TARGET_HOST"

tell application "Safari"
    set winList to every window
    set foundWin to false
    repeat with theWin in winList
        set firstTabURL to get URL of tab 1 of theWin
        if firstTabURL contains targetHost then
            set foundWin to true
            set miniaturized of theWin to false
            set index of theWin to 1
            exit repeat
        end if
    end repeat
    if not foundWin then
        make new document with properties {URL:"https://" & targetHost}
    end if
    activate
end tell
EOF
