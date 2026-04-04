#!/bin/bash

if ! pgrep -x "Music" > /dev/null; then
    open -a "Music"
    exit
fi

osascript <<EOF
tell application "Music"
    try
        set miniVisible to visible of window "MiniPlayer"
        set visible of window "MiniPlayer" to not miniVisible
    on error
        tell application "System Events"
            tell process "Music"
                click menu item "MiniPlayer" of menu "Window" of menu bar 1
            end tell
        end tell
    end try
end tell
EOF
