# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh
#
# A B C D E F G H I J K L M N O P Q R S T U V W X Y Z


case "$(uname)" in
  "Darwin")
    # {{{ MacOS specific exports
    # AWSCLI completions
    fpath=(/opt/homebrew/share/zsh/site-functions/_aws $fpath)

    if [[ -f /Volumes/VeraCrypt/Secret_Files/load-envs-3 ]]; then
      . /Volumes/VeraCrypt/Secret_Files/load-envs-3
    fi
    # }}}
    ;;
  "Linux")
    # {{{ Linux specific exports

    # {{{ AWS CLI
    [ -f $HOME/.aws/bin/v2/current/bin/aws ] && export PATH=$PATH:$HOME/.aws/bin/v2/current/bin
    # }}}

    #{{{ FLUTTER
    export PATH="$PATH:$HOME/flutter/bin"
    export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
    #}}}

    # {{{ JAVA
    # export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
    export JAVA_HOME=/usr/lib/jvm/default
    export ANDROID_HOME=$HOME/android
    export ANDROID_SDK_ROOT=$ANDROID_HOME
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin/
    export PATH=$PATH:$ANDROID_HOME/build-tools/32.0.0/
    # }}}

    # {{{ LANGUAGE
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    # }}}

    # PYTHON {{{
    # poetry
    export PATH=$PATH:"$HOME/.poetry/bin"

    # pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PATH:$PYENV_ROOT/bin"
    if command -v pyenv 1> /dev/null 2>&1; then
      # eval "$(pyenv init -)"
      # eval "$(pyenv init --path)"
      eval "$(pyenv init -)"
    fi
    # }}}

    # {{{ RANGER
    # NOTE: disable
    # export RANGER_LOAD_DEFAULT_RC=FALSE
    # }}}
    #
    # {{{ RUBY
    export PATH=$PATH:$HOME/.gem/ruby/3.2.0/bin
    # }}}

    # {{{ SWAY / Wayland
    export GTK_IM_MODULE=cedilla
    export QT_IM_MODULE=cedilla
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_WEBRENDER=1
    export TERM=wezterm
    export TERMINAL=wezterm
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export QT_STYLE_OVERRIDE=kvantum
    export GTK_THEME=Orchis-Dark-Compact
    export XDG_PICTURES_DIR=$HOME/tmp/screenshots
    # }}}

    # {{{ WEZTERM
    export TERM=wezterm
    # }}}

    # }}}
    ;;
esac


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
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
# }}}

# {{{ GOLANG
if [ -d "$HOME/go/bin" ]; then
  export PATH=$PATH:$HOME/go/bin
fi
# }}}

# {{{ GPG
export GPG_TTY=$(tty)
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
# NO NEEDED in jq version 1.7 (set/2023)
# export JQ_COLORS="2;37" # (null = 2;37 => dim;white)
# }}}

# {{{ KUBERNETES
if [ -d "$HOME/.krew" ]; then
  export PATH=$PATH:"${KREW_ROOT:-$HOME/.krew}/bin"
fi
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

# {{{ RIPGREP
[ -x "$(command -v rg)" ] && export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
# }}}

# {{{ RUST
if [[ -d "$HOME/.cargo" ]]; then
  . "$HOME/.cargo/env"
fi
# }}}

# {{{ ZELLIJ
[ -x "$(command -v zellij)" ] && export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij/
# }}}

# {{{ ZSH
export LISTMAX=-1
export HISTSIZE=50000
export SAVEHIST=30000
export HISTFILE=$HOME/.history

fpath=($HOME/dotfiles/zsh/plugins/zsh-completions/src/ $fpath)
fpath=($HOME/github/zsh/wd/ $fpath)
fpath=($HOME/.scripts/ $fpath)
fpath=($HOME/.local/zsh_completion/ $fpath)
# completions for deno (need to be generated)
fpath=($HOME/.zsh/completions/ $fpath)

# You may have to force rebuild `zcompdump`:
#    rm -f ~/.zcompdump; compinit

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/464
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('kubectl delete *' 'fg=#ffffff,bg=#ff0105')
ZSH_HIGHLIGHT_PATTERNS+=('k delete *' 'fg=#ffffff,bg=#ff0105')
ZSH_HIGHLIGHT_PATTERNS+=('shred *' 'fg=#d86421,bold,bg=default')

typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' fg=123,bold,standout)
ZSH_HIGHLIGHT_REGEXP+=('\b(vim|vi|nvim)\b' fg=#ece600,bold)

# ZSH_HIGHLIGHT_STYLES[cursor]='bg=green'
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main pattern brackets regexp)
# }}}

