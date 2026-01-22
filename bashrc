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

# refresh dotfile links on Windows (skip in Claude Code sessions)
if [ "$MSYSTEM" == "MINGW64" ] && [ -z "$CLAUDECODE" ] ; then
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
    ls_options='-G -D "%Y-%m-%d %H:%M"'
else # linux
    ls_options='--color --time-style=long-iso'
fi
alias ls="ls ${ls_options}"
alias ll="ls -l ${ls_options}"
alias l="ls -la ${ls_options}"

# cd / ls combo
cdd() {
    cd "${1:-$HOME}" && l
}

# git shortcuts
alias g="git"
alias gs="git status"
alias gl="git log -10 --oneline"
alias gd="git diff"
alias gds="git diff --stat"
alias gc="git commit"
alias gca="git commit --all"
alias ga="git commit --amend"
gps() {
  git push origin "$(git symbolic-ref --short HEAD)"
}

gpl() {
  git pull origin "$(git symbolic-ref --short HEAD)"
}

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

# Zettelkasten shortcuts
alias z="cd ~/zk && vim index.md"

# set prompt - from anishathalye/dotfiles/bash/prompt.bash
ATTRIBUTE_BOLD='\[\e[1m\]'
ATTRIBUTE_REVERSE='\[\e[7m\]'
ATTRIBUTE_RESET='\[\e[0m\]'
COLOR_DEFAULT='\[\e[39m\]'
COLOR_RED='\[\e[91m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'
COLOR_GRAY='\[\e[90m\]'

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
      return 1
  fi

  # walk up the process tree looking for sshd
  local pid=$$
  while [[ $pid -gt 1 ]]; do
    local parent comm
    parent=$(ps -o ppid= -p "$pid" 2>/dev/null)
    parent=${parent//[!0-9]/}
    [[ -z "$parent" ]] && break

    comm=$(ps -o comm= -p "$parent" 2>/dev/null)
    [[ "$comm" == "sshd" ]] && return 0

    pid=$parent
  done

  return 1
}

# cache SSH session status (doesn't change mid-session)
if is_ssh_session; then
    _IS_SSH_SESSION=1
else
    _IS_SSH_SESSION=0
fi

parse_git_branch() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      return
  fi

  local branch count display

  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)

  # count all changes: staged, modified, deleted, untracked
  count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -gt 0 ]; then
    echo " • ${COLOR_YELLOW}${branch} ±${count}"
  else
    echo " • ${branch}"
  fi
}

update_prompt() {
    # highlight the user name when logged in as root.
    if [[ "$(whoami)" == "root" ]]; then
        userStyle="${ATTRIBUTE_REVERSE}${COLOR_CYAN}"
    else
        userStyle="${COLOR_CYAN}"
    fi;

    # highlight the hostname when connected via SSH.
    if [[ "$_IS_SSH_SESSION" -eq 1 ]]; then
        hostStyle="[ssh] ${ATTRIBUTE_BOLD}${COLOR_MAGENTA}"
    else
        hostStyle="${COLOR_MAGENTA}"
    fi;

    # display virual environment when active
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv=" • ${VIRTUAL_ENV##*/}"
    else
        venv=""
    fi

    PS1="${COLOR_BLUE}#${COLOR_DEFAULT} ${userStyle}\u${COLOR_DEFAULT}${ATTRIBUTE_RESET} ${COLOR_GREEN}at${COLOR_DEFAULT} ${hostStyle}$(machine_name)${ATTRIBUTE_RESET}${COLOR_DEFAULT} ${COLOR_GREEN}in${COLOR_DEFAULT} ${COLOR_GRAY}\w$(parse_git_branch)${COLOR_GRAY}${venv}${COLOR_DEFAULT}\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)${COLOR_BLUE}>${COLOR_DEFAULT} ${ATTRIBUTE_RESET}"
    PS2="${COLOR_BLUE}>>${COLOR_DEFAULT} "
}

PROMPT_DIRTRIM=3
PROMPT_COMMAND="update_prompt"

# show sysinfo in interactive shells
if [[ $- == *i* ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
