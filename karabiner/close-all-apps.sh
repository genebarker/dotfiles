#!/bin/bash

# Get a list of all open, non-background apps except Finder
APP_LIST=$(osascript <<EOF
tell application "System Events"
	set appNames to name of every process whose background only is false
end tell
return appNames
EOF
)

# Loop through and close each (except Finder)
IFS=", " read -ra APPS <<< "$APP_LIST"
for APP in "${APPS[@]}"; do
	if [[ "$APP" != "Finder" ]]; then
		osascript -e "tell application \"$APP\" to quit"
	fi
done
