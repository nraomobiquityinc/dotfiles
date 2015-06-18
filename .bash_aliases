#!/bin/bash

#------------------------------------------------------
# General *Nix specific stuff
#------------------------------------------------------

# Path
PATH=/usr/local/bin:~/.cabal/bin:$PATH

# Prompt
red=$(tput setaf 1)
bold=$(tput bold)
reverse=$(tput rev)
reset=$(tput sgr0)
#PS1="\[$bold\][\u on \h at \t] \[$red$reverse\]\w\\[$reset\] >> "
PS1="\[$bold\] \[$red$reverse\]\w\\[$reset\] >> "
shopt -s checkwinsize

# for ls - show dotfiles first
export LC_COLLATE="C"

# Aliases
alias ls='ls -Alp'
alias l='ls -xpA --color=auto'
alias h=history
alias gas='git add -A; git status'
alias gaus='git add -u; git status'
alias gd="yes ' ' | git difftool"
alias gb='git branch'
alias gs='git status'
alias gp='git push github `git rev-parse --abbrev-ref HEAD`'
alias gh='git push heroku `git rev-parse --abbrev-ref HEAD`'
alias gl='git log --decorate --graph --oneline'
function gau(){
    git update-index --assume-unchanged $1
}
alias gl='git log'
alias glg='git log -g'
alias gup='git fetch up develop && git rebase up/develop'
alias g='mvim >& /dev/null'
alias gvim='mvim >& /dev/null'
alias vim='mvim'
alias w='cd ~/workspace/haskell/haskell-sandbox'
alias rr='rm -fr'
alias python='python -B'
alias p='python'
alias ru='pkill -u 1000 vmtoolsd; vmtoolsd -n vmusr &' #restart unity
alias t='tree'
alias ta='sudo time-admin' #time and date dialog in xfce
alias r=' source ~/.rvm/scripts/rvm && rvm use 1.8.7' # load ruby 1.8.7
alias psme="ps -ef | grep $(whoami)"
alias ps="ps -ef"

#------------------------------------------------------
# Python
#------------------------------------------------------
##export PYTHONSTARTUP='/home/neeraj/setuppythonenv.py'
#
#if [ ! -f /usr/local/bin/virtualenv ];
#  then sudo pip install virtualenv;
#fi
#
#if [ ! -f /usr/local/bin/virtualenvwrapper.sh ];
#  then sudo pip install virtualenvwrapper;
#fi
#
## More commands: http://docs.python-guide.org/en/latest/dev/virtualenvs/
#export WORKON_HOME=~/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

#------------------------------------------------------
# Mac-specific stuff follows
#------------------------------------------------------
shopt -s cdable_vars
export ws="/Users/nrajrao/workspace/projects"

export JAVA_HOME=$(/usr/libexec/java_home)
export EDITOR="vim"

sonar_install_path="/usr/local/bin/sonarqube"
if [ -d $sonar_install_path ]; # for Sonar
    then
        export SONAR_HOME=$sonar_install_path;
        alias sonar="$SONAR_HOME/bin/macosx-universal-64/sonar.sh"
fi

# set terminal/iterm tab title
function title {
    echo -ne "\033]0;"$*"\007"
}
#export PROMPT_COMMAND='echo -ne "\033]0;$(basename $(PWD))\007"'
