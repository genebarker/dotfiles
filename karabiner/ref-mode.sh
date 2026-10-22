#!/bin/bash

# Reference mode: frontmost window left, terminal right, zoom active pane
# From the terminal, toggle back: maximize and unzoom

R='open -g rectangle://execute-action?name='
TMUX_BIN=/opt/homebrew/bin/tmux

FRONTAPP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

if [ "$FRONTAPP" = "alacritty" ]; then
  ${R}maximize
  $TMUX_BIN if -F '#{window_zoomed_flag}' 'resize-pane -Z'
  exit
fi

${R}left-half
sleep 0.15
open -a Alacritty
sleep 0.15
${R}right-half
$TMUX_BIN if -F '#{window_zoomed_flag}' '' 'resize-pane -Z'
