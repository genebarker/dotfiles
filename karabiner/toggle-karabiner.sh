#!/bin/bash

# Check which app is frontmost
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "Karabiner-Elements" ]; then
  open -a Karabiner-EventViewer
else
  open -a Karabiner-Elements
fi
