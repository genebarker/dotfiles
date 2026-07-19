#!/bin/bash

# List of AI chat apps/sites
# apps=("Gemini" "NotebookLM" "Grok")
apps=("Gemini" "Grok")
state_file="$HOME/.config/gemini-cycle.app"

# Un-minimize a running app's windows via Accessibility, bypassing its own
# (possibly missing) applicationShouldHandleReopen handling. Not currently
# used - GeminiApp is parked below until the native app earns its keep.
restore_app_window() {
  local app_name="$1"
  osascript -e "
    tell application \"System Events\"
      if exists process \"$app_name\" then
        tell process \"$app_name\"
          set frontmost to true
          repeat with w in windows
            if value of attribute \"AXMinimized\" of w is true then
              set value of attribute \"AXMinimized\" of w to false
            end if
          end repeat
        end tell
      end if
    end tell"
}

open_app() {
  case "$1" in
    Gemini) ~/dotfiles/karabiner/open-rsvd-safari-window.sh gemini.google.com ;;
    # GeminiApp)
    #   open -a Gemini
    #   restore_app_window "Gemini"
    #   ;;
    NotebookLM) ~/dotfiles/karabiner/open-rsvd-safari-window.sh notebooklm.google.com ;;
    Grok) ~/dotfiles/karabiner/open-rsvd-safari-window.sh grok.com ;;
  esac
}

# Get the frontmost app
FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# Determine current position (Gemini, NotebookLM, and Grok show up as Safari)
current="$FRONTAPP"
if [ "$FRONTAPP" = "Safari" ]; then
  FRONTURL=$(osascript -e 'tell application "Safari" to get URL of front document')
  if [[ "$FRONTURL" == *"gemini.google.com"* ]]; then
    current="Gemini"
  elif [[ "$FRONTURL" == *"notebooklm.google.com"* ]]; then
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
