# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh

# for debugging performance issues
# zmodload zsh/zprof

# {{{ inspirited by 
# https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.zshrc
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
# https://gist.github.com/aquaductape/3920f646953cade27a623307a959202f
# https://coolsymbol.com/
# }}}

# {{{ INTERNALS 
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

# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt AUTO_CD
setopt AUTO_LIST
setopt AUTO_PUSHD
setopt CLOBBER
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt MENU_COMPLETE
setopt NO_FLOW_CONTROL
setopt NO_NOMATCH
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt SHARE_HISTORY

# vi mode
bindkey -v

# Edit line in vim with ctrl-x x, in visual and insert mode:
# http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/
bindkey '^x^x' edit-command-line
bindkey -M vicmd '^x^x' edit-command-line

bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

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
bindkey "^?" backward-delete-char # fix backspace after change modes
# bindkey -M menuselect '?'   history-incremental-search-backward
bindkey -M menuselect '?'   history-incremental-search-forward
bindkey -M menuselect '^h'  vi-backward-char
bindkey -M menuselect '^k'  vi-up-line-or-history
bindkey -M menuselect '^l'  vi-forward-char
bindkey -M menuselect '^j'  vi-down-line-or-history
bindkey -M menuselect '\e'  undo # closes the completion menu
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next

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

export LS_COLORS="$(vivid generate one-dark)"
# Make completion:
#   Try exact (case-sensitive) match first.
#   Then fall back to case-insensitive.
#   Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
#   Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:descriptions' format '[%d]'
zstyle ':completion:*' menu select=0 search
# zstyle ':completion:*' menu select=0 interactive search

zstyle ':completion:*:*:cp:*' file-sort modification
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:mv:*' file-sort modification

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:*' show-group
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*' fzf-pad 8
zstyle ':fzf-tab:complete:*' fzf-bindings 'ctrl-l:toggle+down,ctrl-h:toggle+up,ctrl-d:half-page-down,ctrl-u:half-page-up'
zstyle ':fzf-tab:*' continuous-trigger '/'
# zstyle ':fzf-tab:*' prefix ' '

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
# https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' git-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}✚%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
zstyle ':vcs_info:git*:*' formats ' %b [%m%c%u] ' # default ' (%s)-[%b]%c%u-'
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
    hook_com[unstaged]+="%F{yellow}■%f"
  fi
}

# conditional show vcs_info
RPS1_ACC=''
precmd() { 
  vcs_info 
  if [[ -n ${vcs_info_msg_0_} ]]; then
    RPS1_ACC='%F{green}%f${vcs_info_msg_0_}%F{blue}%f' #  
  else
    RPS1_ACC='%F{blue}%f'
  fi

  # to change Window Title with the path
  # print "\033]0;>> $(pwd)\007"
  if [[ $TERMINAL == "alacritty" ]]; then
    p=$(pwd)
    slice_path=$p
    IFS=/ parr=(${=p})
    if [ ${#parr[@]} -gt 4 ]; then
      slice_path=$(echo ${parr[-4,-1]} | sed 's/^/.../;s/ /\//g')
    fi
    print "\033]0;:> $slice_path"
  fi
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
    local SUFFIX=$(printf '%%F{$color}▇%.0s%%f' {1..$LVL}) # ❚ ▉ 
    # local SUFFIX=$(printf '%%F{$color}\u2771%.0s%%f' {1..$LVL})
  fi

  # about background jobs count [https://stackoverflow.com/a/10194174]
  # %(1j.%j.)
  # https://unix.stackexchange.com/a/273567/533909
  # export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%(5~|%-1~/…/%3~|%4~)%b%F{243}%B%(1j. ❘%j❘.)%f%F{red}%(?.. ✘)%b%f %B${SUFFIX}%b "
  export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%1~%b%F{243}%B%(1j. ❘%j❘.)%f%F{red}%(?.. ✘)%b%f %B${SUFFIX}%b "

  if [[ -n "$TMUXING" ]]; then
    # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

# typeset -F SECONDS
# function record-start-time() {
#   emulate -L zsh
#   ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
# }

# add-zsh-hook preexec record-start-time

# function report-start-time() {
#   emulate -L zsh
#   if [ $ZSH_START_TIME ]; then
#     local DELTA=$(($SECONDS - $ZSH_START_TIME))
#     local DAYS=$((~~($DELTA / 86400)))
#     local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
#     local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
#     local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
#     local ELAPSED=''
#     test "$DAYS" != '0' && ELAPSED="${DAYS}d"
#     test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
#     test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
#     if [ "$ELAPSED" = '' ]; then
#       SECS="$(print -f "%.2f" $SECS)s"
#     elif [ "$DAYS" != '0' ]; then
#       SECS=''
#     else
#       SECS="$((~~$SECS))s"
#     fi
#     ELAPSED="${ELAPSED}${SECS}"
#     local ITALIC_ON=$'\e[3m'
#     local ITALIC_OFF=$'\e[23m'
#     export RPS1="%F{cyan}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f $RPS1_ACC"
#     unset ZSH_START_TIME
#   else
#     export RPS1=$RPS1_ACC
#   fi
# }

# add-zsh-hook precmd report-start-time

# /etc/motd

if [ -e /etc/motd ]; then
  if ! cmp -s $HOME/.hushlogin /etc/motd; then
    tee $HOME/.hushlogin < /etc/motd
  fi
fi
# }}}


#{{{ SOURCES 
[ -d /home/rods/.yarn/bin ] && export PATH=$HOME/.yarn/bin:$PATH
# bin for python `pip install --user`
[ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:$PATH


# https://gist.github.com/laggardkernel/f319b1baf1065e5d990f11616a1d02b0
function cc {
  # https://invisible-island.net/ncurses/man/clear.1.html
  # https://unix.stackexchange.com/a/375784/246718
  # Behavior of clear: 
  # 1. clear scrollback if E3 cap is supported (terminal, platform specific)
  # 2. then clear visible screen
  # For some terminal 'e[3J' need to be sent explicitly to clear scrollback
  # printf '\e[3J' && clear  # scrollback is kept by `clear`
  clear && printf '\e[3J'
}
export cc

source <(fzf --zsh)
source ~/dotfiles/zsh/plugins/fzf-tab/fzf-tab.zsh
source ~/dotfiles/zsh/plugins/zsh-easy-motion/easy_motion.plugin.zsh
bindkey -M vicmd ' ' vi-easy-motion
source ~/.zsh_alias

if [[ -d "$HOME/.scripts/" ]]; then
  source "$HOME/.scripts/utils.zsh"
  source "$HOME/.scripts/k8s.zsh"
  source "$HOME/.scripts/git-funcs.zsh"
  source "$HOME/.scripts/docker.zsh"
  source "$HOME/.scripts/movie.zsh"
  source "$HOME/.scripts/qr.zsh"
  source "$HOME/.scripts/android.sh"
fi
if [[ -d "$HOME/VPN/" ]]; then
  source "$HOME/VPN/CyberGhost/vpn.sh"
fi

wd() {
  source ~/dotfiles/zsh/plugins/wd/wd.sh
}
# source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/plugins/zsh-lazyload/zsh-lazyload.zsh

lazyload rvm -- '
  export PATH="$PATH:$HOME/.rvm/bin"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
'

if [[ "$(uname)" == "Linux" ]]; then
  lazyload nvm -- '
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  '
fi
if [[ "$(uname)" == "Darwin" ]]; then
  lazyload nvm -- '
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  '
fi

lazyload r.aws -- '
  [ -s "$HOME/.scripts/aws.zsh" ] && source "$HOME/.scripts/aws.zsh"
'

lazyload sqlmap.py -- '
  [ -d $HOME/github/sqlmap ] && export PATH=$PATH:$HOME/github/sqlmap
'

# personal exports (like zoxide)
[ -f $HOME/.personal_exports ] && source $HOME/.personal_exports

# deno
if [[ -f "$HOME/.deno/env" ]]; then
  source "$HOME/.deno/env"
fi
#}}}

autoload -U +X bashcompinit && bashcompinit

if [[ "$(uname)" == "Linux" ]]; then
  # ................. aws ................
  _aws_completion_setup() {
    echo "Loading aws completions..."
    complete -C '/home/rods/.aws/bin/v2/current/bin/aws_completer' aws
    unfunction _aws_completion_setup
  }
  compdef _aws_completion_setup aws

  # ............... awslocal .............
  _awslocal_completion_setup() {
    echo "Loading awslocal completions..."
    complete -C '/home/rods/.aws/bin/v2/current/bin/aws_completer' awslocal
    unfunction _awslocal_completion_setup
  }
  compdef _awslocal_completion_setup awslocal
fi

# .............. kubectl ...............
_kubectl_completion_setup() {
  echo "Loading kubectl completions..."
  source <(kubectl completion zsh)
  unfunction _kubectl_completion_setup
}
compdef _kubectl_completion_setup kubectl

# ................. uv .................
_uv_completion_setup() {
  echo "Loading uv completions..."
  eval "$(uv generate-shell-completion zsh)"
  unfunction _uv_completion_setup
}
compdef _uv_completion_setup uv

# ................ hugo ................
_hugo_completion_setup() {
  echo "Loading hugo completions..."
  source <(hugo completion zsh)
  unfunction _hugo_completion_setup
}
compdef _hugo_completion_setup hugo

# .............. terraform .............
_terraform_completion_setup() {
  echo "Loading terraform completions..."
  complete -o nospace -C /home/rods/.local/bin/terraform terraform
  unfunction _terraform_completion_setup
}
compdef _terraform_completion_setup terraform

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

function export-openai() {
  if [[ "$(uname)" == "Linux" ]]; then
    export OPENAI_API_KEY=$(gpg -qd /disks/Vault/Secret_Files/openai.gpg)
  fi
  if [[ "$(uname)" == "Darwin" ]]; then
    export OPENAI_API_KEY=$(gpg -qd /Volumes/VeraCrypt/Secret_Files/openai.gpg)
  fi
}

function export-anthropic() {
  if [[ "$(uname)" == "Linux" ]]; then
    export ANTHROPIC_API_KEY=$(gpg -qd /disks/Vault/Secret_Files/anthropic.gpg)
  fi
  if [[ "$(uname)" == "Darwin" ]]; then
    export ANTHROPIC_API_KEY=$(gpg -qd /Volumes/VeraCrypt/Secret_Files/anthropic.gpg)
  fi
}

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# for debugging performance issues
# zprof
