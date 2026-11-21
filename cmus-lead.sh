#!/bin/bash

# cmus status_display_program: media keys go to cmus while it has a
# track playing or paused; stopped or quit hands them back to macOS
cli="/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
case "$2" in
    playing|paused) lead=1 ;;
    *) lead=0 ;;
esac
"$cli" --set-variables "{\"cmus_lead\":$lead}"
