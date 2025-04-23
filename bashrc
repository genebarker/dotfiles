#!/usr/bin/env bash

# enable VIM key bindings
set -o vi

# set VIM as editor of choice
export EDITOR=vim

# set bash history options
HISTCONTROL=ignorespace
HISTTIMEFORMAT="%Y-%m-%d %T "
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

# refresh dotfile links on Windows
if [ "$MSYSTEM" == "MINGW64" ] ; then
    $HOME/dotfiles/bsdots -b
    cd ~
fi

# allow aliases to be sudo'ed
alias sudo='sudo '

# switch quickly to super user
alias ssu='sudo su -'

# show path
alias path='echo -e ${PATH//:/\\n}'

# clear screen
alias c='clear'

# protect accidental overwrites
alias cp='cp -i'
alias mv='mv -i'

# cd shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ls shortcuts
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
    ls_colorflag="-G"
else # linux
    ls_colorflag="--color"
fi
alias ls="ls ${ls_colorflag}"
alias ll="ls -l ${ls_colorflag}"
alias l="ls -la ${ls_colorflag}"

# git shortcuts
alias g="git"
alias gg="lazygit"
alias gs="git status"
alias gl="git log -10 --oneline"
alias gd="git diff"
alias gds="git diff --stat"
alias gc="git commit"
alias gca="git commit -a"
alias ga="git commit --amend"
alias gps="git push origin master"
alias gpl="git pull origin master"

# bat alias for debian
if [ -f /etc/debian_version ]
then
    alias bat="batcat"
fi

# vim shortcuts
alias v="vim"

# grep shortcuts
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
    alias G="ggrep -E --color"
    alias GR="ggrep -rE --color"
else # linux
    alias G="grep -E --color"
    alias GR="grep -rE --color"
fi

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
    elif [[ $(uname) == MINGW* ]]; then
        hostname
    else
        hostname -f
    fi
}

is_ssh_session() {
  [[ -n "$SSH_TTY" ]] && return 0
  [[ -n "$SSH_CONNECTION" ]] && return 0

  if [[ $(uname) == MINGW* ]]; then
      # no further checks needed in git bash
      return 1
  fi

  local parent
  parent=$(ps -o ppid= -p "$$")
  parent=${parent//[!0-9]/}  # Strip anything that's not a digit

  if [ -n "$parent" ] && ps -o comm= -p "$parent" 2>/dev/null | grep -q 'sshd'; then
    return 0
  fi

  return 1
}

parse_git_branch() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      return
  fi

  local branch count display

  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)

  # Count all changes: staged, modified, deleted, untracked
  count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -gt 0 ]; then
    display=" ±${count}"
  else
    display=""
  fi

  echo " (${branch}${display})"
}

update_prompt() {
    # highlight the user name when logged in as root.
    if [[ "$(whoami)" == "root" ]]; then
        userStyle="${ATTRIBUTE_REVERSE}${COLOR_CYAN}";
    else
        userStyle="${COLOR_CYAN}";
    fi;

    # highlight the hostname when connected via SSH.
    if is_ssh_session; then
        hostStyle="[ssh] ${ATTRIBUTE_BOLD}${COLOR_MAGENTA}";
    else
        hostStyle="${COLOR_MAGENTA}";
    fi;

    PS1="${COLOR_BLUE}#${COLOR_DEFAULT} ${userStyle}\u${COLOR_DEFAULT}${ATTRIBUTE_RESET} ${COLOR_GREEN}at${COLOR_DEFAULT} ${hostStyle}$(machine_name)${ATTRIBUTE_RESET}${COLOR_DEFAULT} ${COLOR_GREEN}in${COLOR_DEFAULT} ${COLOR_YELLOW}\w${COLOR_GREEN}$(parse_git_branch)${COLOR_DEFAULT}\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)${COLOR_BLUE}>${COLOR_DEFAULT} ${ATTRIBUTE_RESET}"
    PS2="${COLOR_BLUE}>${COLOR_DEFAULT} "
}

PROMPT_DIRTRIM=3
PROMPT_COMMAND="update_prompt"
