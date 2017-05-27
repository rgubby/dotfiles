alias ll="ls -l"
alias ssh="~/bin/ssh"

source ~/.git-prompt.sh
source ~/.git-completion.bash

GREEN='\e[0;32m' 
RED='\e[0;31m'
BLUE='\e[0;34m'
YELLOW='\e[0;33m'
PURPLE='\e[0;35m'
WHITE='\e[0;37m'

PS1="\h: \w\[$YELLOW\]\$(__git_ps1)\[$WHITE\] $ "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

PATH=$PATH:~/bin

cd() {
    command cd $@;
    CURRENT_PWD=`pwd`
    if [ -f "$CURRENT_PWD/.nvmrc" ] ; then
	CURRENT_NODE_VERSION=`nvm current|sed -e 's/^v//'`
        REQUIRED_NODE_VERSION=`nvm which|grep -Eo '<(.*)>'|sed -e 's/[<>]//g'`
        if [ "$CURRENT_NODE_VERSION" != "$REQUIRED_NODE_VERSION" ] ; then
            nvm install >/dev/null
        fi
    fi
}

