#!/bin/bash

# Check which app is frontmost
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "alacritty" ]; then
  open -a Terminal
else
  open -a Alacritty
fi
