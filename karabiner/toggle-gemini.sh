#!/bin/bash

# Check which app is frontmost
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "Gemini" ]; then
  ~/dotfiles/karabiner/open-rsvd-safari-window.sh notebooklm.google.com
else
  open -a Gemini
fi
