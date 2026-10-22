#!/bin/bash

# Cycle reference docs: next Preview window to left half, back to terminal

R='open -g rectangle://execute-action?name='

osascript -e 'tell application "Preview" to set index of last window to 1'
open -a Preview
${R}left-half
sleep 0.15
open -a Alacritty
