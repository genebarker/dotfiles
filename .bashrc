# Enable VIM key bindings
set -o vi

# Eugene's fav aliases
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls --color=auto --group-directories-first -l'
    alias l='ls --color=auto --group-directories-first -lA'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
