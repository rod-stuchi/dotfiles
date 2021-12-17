#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

topp () {
    watch -n 2 -d 'ps -eo pcpu,pid,user,args --no-headers | sort -t. -nk1,2 -k4,4 -r | head -n 20'
}

cpuhz () {
    watch -n 1 -c "lscpu | grep 'CPU MHz'"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

complete -C /home/rods/Downloads/critical/vault-prd/vault vault
