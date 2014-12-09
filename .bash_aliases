#!/bin/bash

# Path
PATH=~/.cabal/bin:$PATH

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

shopt -s cdable_vars
export ws="/Users/nrajrao/workspace/projects"

export JAVA_HOME=$(/usr/libexec/java_home) # for mac

# Aliases
alias ls='ls -Alp'
alias l='ls -xpA --color=auto'
alias h=history
alias gas='git add -A; git status'
alias gaus='git add -u; git status'
alias gd='git diff'
alias gs='git status'
alias gp='git push github `git rev-parse --abbrev-ref HEAD`'
alias gh='git push heroku `git rev-parse --abbrev-ref HEAD`'
alias gl='git log --decorate --graph --oneline'
function gau(){
    git update-index --assume-unchanged $1
}
alias gl='git log'
alias g='mvim'
alias gvim='mvim'
alias w='cd ~/workspace/haskell/haskell-sandbox'
alias rr='rm -fr'
alias python='python -B'
alias p='python'
alias ru='pkill -u 1000 vmtoolsd; vmtoolsd -n vmusr &' #restart unity
alias t='tree'
alias ta='sudo time-admin' #time and date dialog in xfce
alias r=' source ~/.rvm/scripts/rvm && rvm use 1.8.7' # load ruby 1.8.7

## Python
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
#
## ghc-pkg-reset
## Removes all installed GHC/cabal packages, but not binaries, docs, etc.
## Use this to get out of dependency hell and start over, at the cost of some rebuilding time.
#function ghc-pkg-reset() {
#    read -p 'erasing all your user ghc and cabal packages - are you sure (y/n) ? ' ans
#    test x$ans == xy && ( \
#        echo 'erasing directories under ~/.ghc'; rm -rf `find ~/.ghc -maxdepth 1 -type d`; \
#        echo 'erasing ~/.cabal/lib'; rm -rf ~/.cabal/lib; \
#        # echo 'erasing ~/.cabal/packages'; rm -rf ~/.cabal/packages; \
#        # echo 'erasing ~/.cabal/share'; rm -rf ~/.cabal/share; \
#        )
#}
