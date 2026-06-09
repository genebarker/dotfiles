#!/bin/bash

WINDOW_COUNT=$(osascript -e 'tell application "System Events" to tell process "eqMac" to count windows' 2>/dev/null)

if [ "${WINDOW_COUNT:-0}" -gt 0 ]; then
    osascript -e 'tell application "System Events" to tell process "eqMac" to keystroke "w" using {command down}'
else
    open -a eqMac
fi
