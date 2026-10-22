#!/bin/bash

# Cycle reference docs: next Preview window to left half, back to the
# app you pressed it from

R='open -g rectangle://execute-action?name='

FRONTAPP=$(osascript -e 'tell application "System Events" to get bundle identifier of first process whose frontmost is true')

osascript -e 'tell application "Preview" to set index of last window to 1'
open -a Preview
${R}left-half
sleep 0.15
open -b "$FRONTAPP"
