#!/usr/bin/env bash

# enable VIM key bindings
set -o vi

# set VIM as editor of choice
export EDITOR=vim

# set bash history options
HISTSIZE=32768
HISTFILE="$HOME/.bash_history"
SAVEHIST=$HISTSIZE
shopt -s histappend

# load shell dotfiles, use:
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

# set prompt - from anishathalye/dotfiles/bash/prompt.bash
ATTRIBUTE_BOLD='\[\e[1m\]'
ATTRIBUTE_REVERSE='\[\e[7m\]'
ATTRIBUTE_RESET='\[\e[0m\]'
COLOR_DEFAULT='\[\e[39m\]'
COLOR_RED='\[\e[31m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'

machine_name() {
    if [[ -f $HOME/.name ]]; then
        cat $HOME/.name
    else
        hostname -f
    fi
}

# highlight the user name when logged in as root.
if [[ "$(whoami)" == "root" ]]; then
	userStyle="${ATTRIBUTE_REVERSE}${COLOR_CYAN}";
else
	userStyle="${COLOR_CYAN}";
fi;

# highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${ATTRIBUTE_BOLD}${COLOR_MAGENTA}";
else
	hostStyle="${COLOR_MAGENTA}";
fi;

PROMPT_DIRTRIM=3
PS1="${COLOR_BLUE}#${COLOR_DEFAULT} ${userStyle}\\u${COLOR_DEFAULT}${ATTRIBUTE_RESET} ${COLOR_GREEN}at${COLOR_DEFAULT} ${hostStyle}\$(machine_name)${ATTRIBUTE_RESET}${COLOR_DEFAULT} ${COLOR_GREEN}in${COLOR_DEFAULT} ${COLOR_YELLOW}\w${COLOR_DEFAULT}\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)${COLOR_BLUE}>${COLOR_DEFAULT} "
PS2="${COLOR_BLUE}>${COLOR_DEFAULT} "
