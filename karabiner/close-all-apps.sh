#!/bin/bash

#---
# Close the non-background apps
#---
APP_LIST=$(osascript <<EOF
tell application "System Events"
	set appNames to name of every process whose background only is false
end tell
return appNames
EOF
)

IFS=", " read -ra APPS <<< "$APP_LIST"
for APP in "${APPS[@]}"; do
	if [[ "$APP" != "Finder" ]]; then
		osascript -e "tell application \"$APP\" to quit"
	fi
done

#---
# Close the Safari web apps
#---
ps -ax -o pid,command | grep "Web App.app" | grep -- "--bundleidentifier" | awk -F '--bundleidentifier ' '{print $2}' | awk '{print $1}' | while read bundleID; do
  osascript -e "quit app id \"$bundleID\""
done

#---
# Close known apps not caught by above checks
#---
STRAGGLERS=("e-Sword X" "WordWeb Pro")

for APP in "${STRAGGLERS[@]}"; do
  if pgrep -x "$APP" > /dev/null; then
    echo "Closing $APP..."
    osascript -e "tell application \"$APP\" to quit"
  fi
done
