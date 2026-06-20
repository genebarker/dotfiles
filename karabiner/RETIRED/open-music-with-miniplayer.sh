#!/bin/bash

# Open Silicio if not running
if ! pgrep -x "Silicio" > /dev/null; then
    open -a "Silicio"
fi

# Activate Music and ensure normal mode (exit MiniPlayer if active)
osascript <<EOF
tell application "Music"
    activate
    try
        if (exists window "MiniPlayer") and (visible of window "MiniPlayer" is true) then
            tell application "System Events" to tell process "Music"
                click menu item "MiniPlayer" of menu "Window" of menu bar 1
            end tell
        end if
    end try
    reopen
    activate
end tell
EOF
