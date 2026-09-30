#!/bin/bash

# Hide apps on the current Space, leaving just the desktop - or, with
# --others, just the frontmost app. Hide keeps each window's position,
# size, and state - restore with Cmd-Tab or a Warp key. Apps living
# only on other Spaces are spared (Accessibility only sees this
# Space's windows); an app spanning Spaces still hides everywhere.
# If a Finder window is visible on the current Space, Super-0 leaves
# it up: hiding Finder hands focus to the next visible app, even one
# on another Space (e.g. fullscreen RDP), and macOS jumps there.
if [ "$1" = "--others" ]; then keep="front"; else keep="Finder"; fi

osascript <<OSA
tell application "System Events"
  if "$keep" is "front" then
    set keepName to name of first process whose frontmost is true
  else
    set keepName to "Finder"
    set frontmost of process "Finder" to true
  end if
  set targets to name of every application process whose visible is true ¬
      and name is not keepName
  repeat with n in targets
    if (count of windows of process n) > 0 then ¬
      set visible of process n to false
  end repeat
end tell
OSA
