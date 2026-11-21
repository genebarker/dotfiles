#!/bin/bash

# newest albums first in fzf, with each album's tracks in the preview
lib="$HOME/Music/Music/Media.localized/Music"
audio='\.(mp3|m4a|flac|wav|aac)$'
cd "$lib" || exit 0

ls -td */*/ | sed 's#/$##' | fzf --reverse --no-input \
    --bind 'j:down,k:up,q:abort' \
    --preview "ls {} | grep -iE '$audio'" >/dev/null
