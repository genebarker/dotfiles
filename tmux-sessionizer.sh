#!/bin/sh
# fuzzy-pick a project under ~/workspace, switch to its tmux session
dir=$(ls -d ~/workspace/*/ | fzf) || exit 0
name=$(basename "$dir" | tr . _)  # tmux session names can't hold a dot
tmux has-session -t "=$name" 2>/dev/null ||
    tmux new-session -d -s "$name" -c "$dir"
tmux switch-client -t "=$name"
