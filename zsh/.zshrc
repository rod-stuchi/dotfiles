# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number

# {{{ inspirited by 
# https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.zshrc
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
# https://gist.github.com/aquaductape/3920f646953cade27a623307a959202f
# https://coolsymbol.com/
# }}}

# {{{ EXPORTS 
fpath=(/usr/share/zsh/site-functions/ $fpath)
fpath=(~/github/zsh/wd/ $fpath)
fpath=(~/.scripts/ $fpath)

export KEYTIMEOUT=1 # vi mode
#export MANPAGER="nvim -c 'set ft=man' -"

# {{{ less config 
# ESC+ESC to exit
# https://unix.stackexchange.com/a/183486 
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export LESS=-XRFiS                     # colors, do not clear on exit, exit if fits screen, ignorecase
# }}}

# {{{ jq config
# LINK, REF: https://stackoverflow.com/a/51341700
# COLOR Definition "1;37"
#  - 1 (bright)
#  - 2 (dim)
#  - 4 (underscore)
#  - 5 (blink)
#  - 7 (reverse)
#  - 8 (hidden)
#
#  - 30 (black)
#  - 31 (red)
#  - 32 (green)
#  - 33 (yellow)
#  - 34 (blue)
#  - 35 (magenta)
#  - 36 (cyan)
#  - 37 (white)
#
# JQ_COLORS="null:false:true:numbers:strings:arrays:objects"
#
export JQ_COLORS="2;37" # (null = 2;37 => dim;white)
# }}}

export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export RANGER_LOAD_DEFAULT_RC=FALSE

export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --no-messages --follow --glob "!.git" --glob "!node_modules" --glob "!.yarn" '
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--bind 'ctrl-a:select-all+accept'"
export FZF_DEFAULT_OPTS='--color fg+:190,bg+:235,hl:210,hl+:208,pointer:208,marker:202 --border --margin=1 --padding=1 --info=inline'

# ripgrep config
[ -x "$(command -v rg)" ] && export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# python poetry
export PATH="$HOME/.poetry/bin:$PATH"

# python pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

if command -v pyenv 1> /dev/null 2>&1; then
  # eval "$(pyenv init -)"
  # eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# for android sdkmanager
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export ANDROID_HOME=$HOME/android
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH=$PATH:/$HOME/develop/criticalmass/dialog-admin/aws/dist

# Cargo
export PATH=$PATH:$HOME/.cargo/bin

# AWS CLI
[ -f $HOME/.aws/bin/v2/current/bin/aws ] && export PATH=$PATH:$HOME/.aws/bin/v2/current/bin

# Golang bin
export PATH=$PATH:$HOME/go/bin
# }}}

# {{{ INTERNALS 
# {{{ loads, var, sets 
typeset -A __ARR
__ARR[ITALIC_ON]=$'\e[3m'
__ARR[ITALIC_OFF]=$'\e[23m'

# History
HISTSIZE=50000
SAVEHIST=30000
HISTFILE=~/.history

autoload -U colors
colors

zmodload zsh/complist


autoload -U compinit
compinit -u
#_comp_options+=(globdots)		# Include hidden files.

autoload -Uz vcs_info

autoload -U add-zsh-hook

autoload edit-command-line
zle -N edit-command-line

# ci"
autoload -U select-quoted
zle -N select-quoted

# ci{, ci(, di{ etc..
autoload -U select-bracketed
zle -N select-bracketed

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

setopt PROMPT_SUBST
#setopt AUTO_RESUME             # allow simple commands to resume backgrounded jobs
#setopt CORRECT                 # [default] command auto-correction
#setopt CORRECT_ALL             # [default] argument auto-correction
#setopt IGNORE_EOF              # [default] prevent accidental C-d from exiting shell
#setopt PRINT_EXIT_VALUE        # [default] for non-zero exit status
setopt AUTO_CD                 # [default] .. is shortcut for cd .. (etc)
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt AUTO_PUSHD              # [default] cd automatically pushes old dir onto dir stack
setopt CLOBBER                 # allow clobbering with >, no need to use >!
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt INTERACTIVE_COMMENTS    # [default] allow comments, even in interactive shells
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter duplicates from history
setopt NO_HIST_IGNORE_DUPS     # don't filter contiguous duplicates from history
setopt NO_NOMATCH              # [default] unmatched patterns are left unchanged
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT            # [default] don't print dir stack after pushing/popping
setopt SHARE_HISTORY           # share history across shells
# }}}

# {{{ keys bindings 
# vi mode
bindkey -v

# Edit line in vim with ctrl-x x, in visual and insert mode:
# http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/
bindkey '^x^x' edit-command-line
bindkey -M vicmd '^x^x' edit-command-line

bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

bindkey '^Z' ctrlz # toogle background
# bindkey '^Y' accept-search

bindkey -M emacs '^ ' magic-space # do history expansion on space
bindkey -M viins '^ ' magic-space # do history expansion on space
bindkey -M emacs ' ' expand-alias # do alias expansion on space
bindkey -M viins ' ' expand-alias # do alias expansion on space
bindkey -M isearch " " magic-space # normal space during searches

# shift+tab select back
bindkey -M menuselect '^[[Z' reverse-menu-complete

bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '\e' undo # closes the completion menu
bindkey "^?" backward-delete-char # fix backspace after change modes

bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

bindkey "^a" beginning-of-line
bindkey -M vicmd "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey -M vicmd "^e" end-of-line

# alt+->
bindkey "^[[1;3C" forward-word
# alt+<-
bindkey "^[[1;3D" backward-word
# empty line
bindkey "^u"    backward-kill-line
bindkey "^[l"   down-case-word
# }}}

# {{{ functions 
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ci"
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, di{ etc..
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

ctrlz() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}

zle -N ctrlz

# Make completion:
#   Try exact (case-sensitive) match first.
#   Then fall back to case-insensitive.
#   Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
#   Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
export LS_COLORS="$(vivid generate one-dark)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__ARR[ITALIC_ON]%}... %d ...%{$__ARR[ITALIC_OFF]%}%b%f
#_zstyle ':completion:*' menu select
#_zstyle ':completion:*' menu select=0 search
zstyle ':completion:*' menu select=0 interactive

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
# https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' git-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}✚%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
zstyle ':vcs_info:git*:*' formats '[%b %m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "+${ahead}" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{011}■%f"
  fi
}

# conditional show vcs_info
RPS1_ACC=''
precmd() { 
  vcs_info 
  if [[ -n ${vcs_info_msg_0_} ]]; then
    RPS1_ACC='%F{green}%f${vcs_info_msg_0_}%F{blue}%~%f' #  
  else
    RPS1_ACC='%F{blue}%~%f'
  fi

  # to change Window Title with the path
  # print "\033]0;>> $(pwd)\007"
  [[ $TERM == "alacritty" ]] && print "\033]0;:> $(pwd)"
}

# Anonymous function to avoid leaking variables.
function () {
  # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)

  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # In a a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 2))
  else
    # Either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$(($SHLVL - 1))
  fi

  if [[ $EUID -eq 0 ]]; then
    local SUFFIX='%F{yellow}%n%f'$(printf '%%F{yellow}\u275a%.0s%%f' {1..$LVL})
  else
    #for code in {000..255}; do print -P -- "$code: %F{$code}Color%f"; done
    # random colors at prompt >
    color=$(printf "%03d" $[RANDOM%255+1])
    local SUFFIX=$(printf '%%F{$color}\u275a%.0s%%f' {1..$LVL})
    # local SUFFIX=$(printf '%%F{$color}\u276f%.0s%%f' {1..$LVL})
    # local SUFFIX=$(printf '%%F{$color}\u2771%.0s%%f' {1..$LVL})
  fi

  # about background jobs count [https://stackoverflow.com/a/10194174]
  # %(1j.%j.)
  export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%1~%b%F{243}%B%(1j. ❘%j❘.)%f%F{red}%(?.. ✘)%b%f %B${SUFFIX}%b "

  if [[ -n "$TMUXING" ]]; then
    # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

# for CORRECT and CORRECT_ALL
#export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "


typeset -F SECONDS
function record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec record-start-time

function report-start-time() {
  emulate -L zsh
  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    local ITALIC_ON=$'\e[3m'
    local ITALIC_OFF=$'\e[23m'
    export RPS1="%F{cyan}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f $RPS1_ACC"
    unset ZSH_START_TIME
  else
    export RPS1=$RPS1_ACC
  fi
}

add-zsh-hook precmd report-start-time

expand-alias() {
  [[ $LBUFFER =~ "\<(${(j:|:)baliases})\$" ]]; insertBlank=$?
  if [[ ! $LBUFFER =~ "\<(${(j:|:)ialiases})\$" ]]; then
    zle _expand_alias
  fi
  zle self-insert
  if [[ "$insertBlank" = "0" ]]; then
    zle backward-delete-char
  fi
}
zle -N expand-alias
# }}}

# {{{ motd 
# /etc/motd

if [ -e /etc/motd ]; then
  if ! cmp -s $HOME/.hushlogin /etc/motd; then
    tee $HOME/.hushlogin < /etc/motd
  fi
fi
# }}}

# }}}

# {{{ ALIASES 
# https://blog.sebastian-daschner.com/entries/zsh-aliases
# blank aliases
typeset -a baliases
baliases=()

balias() {
  alias $@
  args="$@"
  args=${args%%\=*}
  baliases+=(${args##* })
}

# ignored aliases
typeset -a ialiases
ialiases=()

ialias() {
  alias $@
  args="$@"
  args=${args%%\=*}
  ialiases+=(${args##* })
}


# blank aliases, without trailing whitespace
balias clh='curl localhost:'

# "ignored" aliases, not expanded
ialias ls="ls --color=always"
ialias lss="exa --icons -lh -s=Extension"
ialias ll="ls -lh --color=always"
ialias lla="ls -lha --color=always"
ialias z="zshz 2>&1"
ialias j="zjump"
ialias {vim,vi}="nvim"
ialias k="kubectl"

alias gst="git status"
alias ga="git add"
alias gau="git add -u"
alias gco="git checkout"
alias gsm="git switch master"
alias gsw="git switch"
alias gd="git diff"
alias gdca="git diff --cached"
alias gdi="git diff ':(exclude)yarn.lock' ':(exclude)package-lock.json'"
alias gdcai="git diff --cached ':(exclude)yarn.lock' ':(exclude)package-lock.json'"
alias gp="git push"
alias grc="git rebase --continue"
alias gpp="git pull --prune"
balias gcms="git commit -m \""
balias gcm="git commit"
alias glb="git log --graph --oneline --branches"
alias gll="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias {df,DF}='df -Th'
alias {distro,DISTRO}='cat /etc/[A-Za-z]*[_-][rv]e[lr]* ; print "Kernel $(uname -r)"'
alias sctl='sudo systemctl'
alias sctls='sudo systemctl status'
alias sctlsta='sudo systemctl start'
alias sctlsto='sudo systemctl stop'
alias sctlres='sudo systemctl restart'
alias sctle='sudo systemctl enable'
alias sctld='sudo systemctl disable'

alias serviio='/disks/2TB/apps-linux/serviio/serviio-2.0/bin/serviio.sh'

alias t="trans en:pt --speak "
alias p="trans pt:en "

alias ss="sudo ss -tulpn"
# ialias dockerps='(echo "ID#IMAGE#PORTS#Created"; docker ps --format "{{.ID}}#{{.Image}}#{{.Ports}}#{{.CreatedAt}}") | column -t -s#'
ialias dockerps='(docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}\t{{.State}}")'
# }}}

#{{{ SOURCES 
[ -d /home/rods/.yarn/bin ] && export PATH=$HOME/.yarn/bin:$PATH
# bin for python `pip install --user`
[ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:$PATH

source ~/.scripts/utils.zsh
source ~/.scripts/k8s.zsh
source ~/.scripts/git-funcs.zsh
source ~/.scripts/docker.zsh
source ~/.scripts/movie.zsh
source ~/.scripts/qr.zsh
source ~/.scripts/android.sh
source ~/VPN/CyberGhost/vpn.sh

r.receipt() {
  # TODO fazer a função com 3 paramêtros
}

source ~/.fzf.zsh

r.fzffd() {
  bash ~/.scripts/fzf/fzffd.sh
}
r.fzfrg() {
  bash ~/.scripts/fzf/fzfrg.sh
}
r.fzfrg2() {
  bash ~/.scripts/fzf/fzfrg2.sh
}
r.fzfrgi() {
  bash ~/.scripts/fzf/fzfrgi.sh
}

# source ~/github/zsh/zsh-z/zsh-z.plugin.zsh
# source ~/github/zsh/zjump/zjump.zsh
#source ~/github/zsh/forgit/forgit.plugin.sh
wd() {
  source ~/github/zsh/wd/wd.sh
}
#source ~/github/zsh/oh-my-zsh/plugins/git/git.plugin.zsh
source ~/github/zsh/oh-my-zsh/plugins/dotenv/dotenv.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/github/zsh/zsh-lazyload/zsh-lazyload.zsh

lazyload rvm -- '
  export PATH="$PATH:$HOME/.rvm/bin"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
'

lazyload nvm -- '
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
'

lazyload r.aws -- '
  [ -s "$HOME/.scripts/aws.zsh" ] && source "$HOME/.scripts/aws.zsh"
'

lazyload sqlmap.py -- '
[ -d $HOME/github/sqlmap ] && export PATH=$PATH:$HOME/github/sqlmap

'
# personal exports (like zoxide)
[ -f $HOME/.personal_exports ] && source $HOME/.personal_exports

#}}}

#{{{ WORKAROUND
if [ ! -f ~/.__localstate ]; then
  systemctl --user restart dunst.service 
  notify-send send -t 500 "dunst ok"
  xmodmap ~/.Xmodmap &> /dev/null
  touch .__localstate
fi
#}}}

autoload -U +X bashcompinit && bashcompinit

# AWS-CLI
complete -C '/home/rods/.aws/bin/v2/current/bin/aws_completer' aws

# # zoxide
eval "$(zoxide init zsh)"

