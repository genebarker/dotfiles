#!/bin/bash

# Check which app is frontmost
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "Things3" ]; then
  open -a "Just Press Record"
else
  open -a Things3
fi
