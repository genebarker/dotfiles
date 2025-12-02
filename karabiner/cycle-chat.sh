#!/bin/bash

# List of messaging apps
apps=("Grok" "ChatGPT")
# Commenting out for now - using Claude via Claude Code instead
# apps=("Grok" "ChatGPT" "Gemini" "Claude")
state_file="$HOME/.config/chat.app"

# Get title of frontmost app
FRONTTITLE=$(osascript -e 'tell application "System Events" to tell (first process whose frontmost is true) to get title of front window')

# Find index of frontmost app in the list
index=-1
for i in "${!apps[@]}"; do
  if [[ "$FRONTTITLE" =~ "${apps[$i]}" ]]; then
    index=$i
    break
  fi
done

if [ $index -ge 0 ]; then
  # If frontmost app is in the list, switch to the next one
  next_index=$(( (index + 1) % ${#apps[@]} ))
  next_app="${apps[$next_index]}"
  echo "$next_app" > "$state_file"
  open -a "$next_app"
else
  # Otherwise, open the last used messaging app or default to the first
  if [ -f "$state_file" ]; then
    last_app=$(cat "$state_file")
  else
    last_app="${apps[0]}"
  fi
  open -a "$last_app"
fi
