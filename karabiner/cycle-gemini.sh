#!/bin/bash

# List of AI chat apps/sites
apps=("Gemini" "NotebookLM" "Grok")
state_file="$HOME/.config/gemini-cycle.app"

open_app() {
  case "$1" in
    Gemini) open -a Gemini ;;
    NotebookLM) ~/dotfiles/karabiner/open-rsvd-safari-window.sh notebooklm.google.com ;;
    Grok) ~/dotfiles/karabiner/open-rsvd-safari-window.sh grok.com ;;
  esac
}

# Get the frontmost app
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# Determine current position (NotebookLM and Grok show up as Safari)
current="$FRONTAPP"
if [ "$FRONTAPP" = "Safari" ]; then
  FRONTURL=$(osascript -e 'tell application "Safari" to get URL of front document')
  if [[ "$FRONTURL" == *"notebooklm.google.com"* ]]; then
    current="NotebookLM"
  elif [[ "$FRONTURL" == *"grok.com"* ]]; then
    current="Grok"
  fi
fi

# Find index of current app in the list
index=-1
for i in "${!apps[@]}"; do
  if [ "${apps[$i]}" = "$current" ]; then
    index=$i
    break
  fi
done

if [ $index -ge 0 ]; then
  # If frontmost app is in the list, switch to the next one
  next_index=$(( (index + 1) % ${#apps[@]} ))
  next_app="${apps[$next_index]}"
  echo "$next_app" > "$state_file"
  open_app "$next_app"
else
  # Otherwise, open the last used app or default to the first
  if [ -f "$state_file" ]; then
    last_app=$(cat "$state_file")
  else
    last_app="${apps[0]}"
  fi
  open_app "$last_app"
fi
