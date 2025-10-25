#!/bin/bash

if ! pgrep -x "Safari" > /dev/null; then
    open -a "Safari"
    exit
fi

osascript <<EOF
set reservedHosts to {"github.com/genebarker", "calendar.google.com", "voice.google.com", "x.com", "youtube.com"}

tell application "Safari"
    set winList to every window
    set foundWin to false
    repeat with theWin in winList
        set firstTabURL to get URL of tab 1 of theWin
        set reservedWin to false
        repeat with theHost in reservedHosts
            if firstTabURL contains theHost then
                set reservedWin to true
                exit repeat
            end if
        end repeat
        if not reservedWin then
            set foundWin to true
            set index of theWin to 1
            exit repeat
        end if
    end repeat
    if not foundWin then
        make new document
    end if
    activate
end tell
EOF
