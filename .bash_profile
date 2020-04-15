# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Setting PATH for PostgreSQL 12
PATH="/Library/PostgreSQL/12/bin:${PATH}"
export PATH

# Eugene's python helpers
function hhset() {
    export VENV="/Users/eugene/workspace/$@"
    export FLASK_APP="$@"
    export FLASK_ENV=development
    cd $VENV
    . venv/bin/activate
}
alias hhcd='cd $VENV'
alias hht='$VENV/venv/bin/pytest -q'
alias hhtv='$VENV/venv/bin/pytest -v'
alias hhtc='$VENV/venv/bin/pytest --cov'
alias hhrun='cd $VENV && $VENV/venv/bin/flask run'

# Eugene's fav aliases
alias ls='ls -G'
alias ll='ls -Gl'
alias l='ls -Gla'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

