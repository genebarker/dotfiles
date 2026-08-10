#!/bin/bash

osascript <<'EOF'
tell application "System Events"
  set procList to every application process whose visible is true
  repeat with proc in procList
    repeat with win in every window of proc
      try
        set value of attribute "AXMinimized" of win to true
      end try
    end repeat
  end repeat
end tell
EOF
