#!/bin/bash

# Check which app is frontmost
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "Dictionary" ]; then
  open -a "WordWeb Pro"
else
  open -a "Dictionary"
fi
