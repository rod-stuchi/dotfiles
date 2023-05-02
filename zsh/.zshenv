# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh
#
# A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
#
# {{{ AWS CLI
[ -f $HOME/.aws/bin/v2/current/bin/aws ] && export PATH=$PATH:$HOME/.aws/bin/v2/current/bin
# }}}

# EDITOR {{{
export EDITOR=nvim
export VISUAL=nvim
export KEYTIMEOUT=1 # vi mode

# }}}

# FZF {{{
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --no-messages --follow --glob "!.git" --glob "!node_modules" --glob "!.yarn" '
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--bind 'ctrl-a:select-all+accept'"
export FZF_DEFAULT_OPTS='--color fg+:190,bg+:235,hl:210,hl+:208,pointer:208,marker:202 --border --margin=1 --padding=1 --info=inline --pointer=" " --marker="→"'
# }}}

# {{{ GOLANG
export PATH=$PATH:$HOME/go/bin
# }}}

# {{{ GPG
export GPG_TTY=$(tty)
# }}}

# {{{ JAVA
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export ANDROID_HOME=$HOME/android
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# }}}

# {{{ JQ
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

# {{{ KUBERNETES
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# }}}

# {{{ LANGUAGE
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# }}}

# {{{ LESS
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

# PYTHON {{{
#  PYTHON poetry
export PATH="$HOME/.poetry/bin:$PATH"

# PYTHON pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1> /dev/null 2>&1; then
  # eval "$(pyenv init -)"
  # eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
# }}}

# {{{ RANGER
export RANGER_LOAD_DEFAULT_RC=FALSE
# }}}

# {{{ RIPGREP
[ -x "$(command -v rg)" ] && export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
# }}}

# {{{ RUST
export PATH=$PATH:$HOME/.cargo/bin
# }}}

# {{{ ZELLIJ
export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij/
# }}}

# {{{ ZSH
export LISTMAX=-1
export HISTSIZE=50000
export SAVEHIST=30000
export HISTFILE=~/.history

fpath=(~/dotfiles/zsh/plugins/zsh-completions/src/ $fpath)
fpath=(~/github/zsh/wd/ $fpath)
fpath=(~/.scripts/ $fpath)
fpath=(~/.local/zsh_completion/ $fpath)

# You may have to force rebuild `zcompdump`:
#    rm -f ~/.zcompdump; compinit

# }}}

# {{{ WEZTERM
export TERM=wezterm
# }}}
