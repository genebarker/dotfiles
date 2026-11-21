#!/bin/bash

# newest albums first in fzf, with each album's tracks in the preview;
# Enter jumps to cmus (when it runs in tmux), q or Esc stays put
lib="$HOME/Music/Music/Media.localized/Music"
audio='\.(mp3|m4a|flac|wav|aac)$'
cd "$lib" || exit 0

ls -td */*/ | sed 's#/$##' | fzf --reverse --no-input \
    --bind 'j:down,k:up,q:abort' \
    --preview "ls {} | grep -iE '$audio'" >/dev/null || exit 0
pane=$(tmux list-panes -a -F '#{pane_id} #{pane_current_command}' \
    | awk '$2 == "cmus" { print $1; exit }')
[ -n "$pane" ] || exit 0
tmux switch-client -t "$pane" \; select-window -t "$pane" \; select-pane -t "$pane"
