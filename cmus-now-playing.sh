#!/bin/sh
# "Album 2/10 - Title" for the tmux bar; prints nothing unless playing
cmus=/opt/homebrew/bin/cmus-remote
$cmus -Q 2>/dev/null | grep -q '^status playing' || exit 0

file=$($cmus -Q | sed -n 's/^file //p')
name=${file##*/}
case $name in
    [0-9]-[0-9][0-9]\ *) disc="${name%%-*}-" ;;  # count this disc only
    *) disc="" ;;
esac
total=$(ls "${file%/*}" | grep -ci -E "^$disc.*\.(mp3|m4a|flac)$")

export LC_ALL=en_US.UTF-8  # cut by character, not byte
album=$($cmus -C 'format_print "%l"' | sed -E 's/ [(\[].*//' | cut -c1-28)
case $($cmus -C 'format_print "%D"') in
    2) album="${album}²" ;;
    3) album="${album}³" ;;
esac
track=$($cmus -C 'format_print "%n"')
title=$($cmus -C 'format_print "%t"')
printf ' %s %s/%s - %s \n' "$album" "$track" "$total" "$title"
