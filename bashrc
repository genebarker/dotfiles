#!/usr/bin/env bash

# Enable VIM key bindings
set -o vi

# Set VIM as editor of choice
export EDITOR=vim

# Set bash history options
HISTSIZE=32768
HISTFILE="$HOME/.bash_history"
SAVEHIST=$HISTSIZE
shopt -s histappend

# Load shell dotfiles, use:
# ~/.path to set $PATH for host
# ~/.extra to customize for host
for file in ~/.{path,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# adjust command flags for OS
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
    ls_colorflag="-G"
else # linux
    ls_colorflag="--color"
fi

# allow aliases to be sudo'ed
alias sudo='sudo '

# show path
alias path='echo -e ${PATH//:/\\n}'

# protect accidental overwrites
alias cp='cp -i'
alias mv='mv -i'

# cd shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ls shortcuts
alias ls="ls ${ls_colorflag}"
alias ll="ls -l ${ls_colorflag}"
alias l="ls -la ${ls_colorflag}"

# git shortcuts
alias g="git"
alias gs="git status"
alias gl="git log -10 --oneline"
alias ga="git commit --amend"
alias gd="git diff"
alias gds="git diff --stat"

# vim shortcuts
alias v="vim"

# grep shortcuts
alias grep="grep --color"

# Flask project shortcuts
function hhset() {
    export VENV="$HOME/workspace/$@"
    export FLASK_APP="$@"
    export FLASK_ENV=development
    cd $VENV
    . venv/bin/activate
}
alias hhcd='cd $VENV'
alias hht='$VENV/venv/bin/pytest -q'
alias hhtv='$VENV/venv/bin/pytest -v'
alias hhtc='$VENV/venv/bin/pytest --cov=$FLASK_APP'
alias hhrun='cd $VENV && $VENV/venv/bin/flask run'
