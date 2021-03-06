# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# zsh: do not save in history when starts with space
setopt HIST_IGNORE_SPACE

case `uname` in
  Darwin)
    export ANDROID_HOME=~/Library/Android/sdk/
  ;;
  Linux)
    # export ANDROID_HOME=/disks/1TB/android
    export ANDROID_SDK_ROOT=/disks/1TB/android
  ;;
esac
# ================================= ANDROID =================================
# ANDROID_SDK_ROOT
# [ -d $ANDROID_HOME/sdk/bin ]                        && export PATH=$PATH:$ANDROID_HOME/sdk/bin
# [ -d $ANDROID_HOME/tools ]                          && export PATH=$PATH:$ANDROID_HOME/tools
# [ -d $ANDROID_HOME/platform-tools ]                 && export PATH=$PATH:$ANDROID_HOME/platform-tools
[ -d $ANDROID_SDK_ROOT/sdk/bin ]                      && export PATH=$PATH:$ANDROID_SDK_ROOT/sdk/bin
[ -d $ANDROID_SDK_ROOT/tools ]                        && export PATH=$PATH:$ANDROID_SDK_ROOT/tools
[ -d $ANDROID_SDK_ROOT/platform-tools ]               && export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
# =================================== RUBY ==================================
[ -d $HOME/.rvm/bin ]                               && export PATH="$PATH:$HOME/.rvm/bin"
[ -d $HOME/.gem/ruby/2.5.0/bin ]                    && export PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
# =================================== NODE ==================================
# [ -d ~/.asdf/installs/nodejs/8.9.4/.npm/bin ]       && export PATH=~/.asdf/installs/nodejs/8.9.4/.npm/bin:$PATH
[ -d $HOME/.config/yarn/global/node_modules/.bin ]  && export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
# [ -d $HOME/.asdf/installs/nodejs/8.9.4/.npm/bin ]   && export PATH="$PATH:$HOME/.asdf/installs/nodejs/8.9.4/.npm/bin"

[ -x "$(command -v rg)" ]                           && export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1> /dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export MANPAGER="nvim -c 'set ft=man' -"
export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export RANGER_LOAD_DEFAULT_RC=FALSE

export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --no-messages --follow --glob "!.git" --glob "!node_modules"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--bind 'ctrl-a:select-all+accept'"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh # || \

# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
  adb
  bundler
  colorize
  dirhistory
  docker
  dotenv
  encode64
  git
  git-extras
  jsontools
  jump
  mix
  node
  osx
  pip
  react-native
  ruby
  sudo
  vi-mode
  yarn
  z
)

# removes timeout when switching to normal mode (vi-mode)
export KEYTIMEOUT=1

source $ZSH/oh-my-zsh.sh
# . $HOME/.asdf/asdf.sh
# . $HOME/.asdf/completions/asdf.bash

if [[ `uname` == "Linux" ]] then
  if [[ $TERM =~ konsole.* ]]; then
      export FZF_DEFAULT_OPTS='--color fg+:5,hl+:6'
  fi

  if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    __vte_osc7

    BASE16_SHELL=$HOME/.config/base16-shell/
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
  fi
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias cd..="cd .."
if [ -d $ANDROID_HOME/emulator ]; then
  alias emulator-avd="$ANDROID_HOME/emulator/emulator -avd"
  alias emulator-avds="$ANDROID_HOME/emulator/emulator -list-avds"
fi
alias ggit="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias gitroot="/usr/bin/git --git-dir=/home/rods/.gitroot --work-tree=/"
alias gllog="git log --pretty=\"format:%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(17,trunc)%aN%C(auto,reset)%s%C(auto,red)\""
alias glllog="git log --pretty=\"format:%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(17,trunc)%aN%C(auto,reset)%s%C(auto,red)% gD% D\""
alias gtr="git --no-pager tag --sort=-creatordate"
alias ld="ls -d */"
alias lld="ls -ld */"

if [ -d ~/.scripts ]; then
  alias rodsAmexFatura='~/.scripts/amex/fatura'
  alias rodsVivoDec='~/.scripts/vivo/decrypt'
  alias rodsClaroDec='~/.scripts/claro/decrypt'
  alias rodsComGasDec='~/.scripts/comgas/decrypt'
  alias rodsComGasFatura='~/.scripts/comgas/fatura'
  alias rodsCpAll='~/.scripts/comprovantes/all'
  alias rodsCpMonth='~/.scripts/comprovantes/month'
  alias rodsCpMonthF='~/.scripts/comprovantes/monthf'
  alias rodsNetFatura='~/.scripts/net/fatura'
  alias rodsNubankFatura='~/.scripts/nubank/fatura'
  alias rodsSubmarinoDec='~/.scripts/submarino/decrypt'
  alias rodsSubmarinoFatura='~/.scripts/submarino/fatura'
  alias xmovsub="~/.scripts/xmovsub.sh"
  alias xmovdir="~/.scripts/xmovdir.sh"
  alias mega-sena="~/.scripts/mega-sena/mega-sena.js"
fi

if [[ `uname` == "Linux" ]] then
  alias clipget="xclip -selection clipboard -o"
  alias clipset="xclip -selection clipboard"
  alias rodsDisableWebCam='sudo modprobe -r uvcvideo'
  alias rodsEnableWebCam='sudo modprobe -a uvcvideo'
  alias rodsMemo='function _memo(){smem -t -k -c pss -P "$1" | tail -n 1}; _memo'
  alias rodsmpd='mpd -v .config/mpd/mpd.conf'
  alias rodsdisk="df -h -l -t ext4 -t fuseblk"

  rodsListWifi() {
    iwlist wlp3s0 scan | ag "ESSID|Encryp|Quality" | xargs -L2 | sort -rk 1
  }

  rodsPacRequiredBy() {
    pacman -Qi "$1" | awk -F'[:<=>]' '/^Required/ {print $2}' | xargs -n1 | sort -u
  }

  rodsPacDependsOn() {
    pacman -Si "$1" | awk -F'[:<=>]' '/^Depends/ {print $2}' | xargs -n1 | sort -u
  }

  rodsMicStaticVolume() {
    VOLP=30
    [[ ! -z $1 ]] && VOLP=$1
    VOLV=$(($VOLP * 65530 / 100))
    # ref link: https://askubuntu.com/a/829996
    while sleep 0.001; do pacmd set-source-volume alsa_input.pci-0000_00_1b.0.analog-stereo $VOLV; done
  }

  rodsColor () {
    #find ~/.config/i3/base16/ -perm -u+x | xargs -L 1 basename | fzf --bind 'enter:execute(~/.config/i3/base16/{})+abort'
    find ~/.config/i3/base16/ -perm -u+x | xargs -L 1 basename \
      | fzf \
      | xargs -i sh -c '~/.config/i3/base16/{} && ~/.config/termite/base16/{} && sed -i -e "s/colorscheme base16-.*/colorscheme base16-{}/" ~/.config/nvim/init.vim'

    echo "~/.config/i3/config ::"
    cat ~/.config/i3/config | head -n 22 | sed -e 's/^/          /g'
    echo "~/.config/termite/config ::"
    cat ~/.config/termite/config | head -n 30 | sed -e 's/^/          /g'
    echo "~/.config/nvim/init.vim ::"
    cat ~/.config/nvim/init.vim | tail -n +153 | head -8 | sed -e 's/^/          /g'
  }

  rodsCreateFile () {
    if [[ -z $1 || -z $2 ]]; then
    echo 'usage:
      rodsCreateFile name size
        name  - any string without spaces
        size  - in MB

      $ rodsCreateFile file.txt 10
    '
    return 0
    fi
    dd if=/dev/urandom of=$1 bs=1048576 count=$2
  }

  # get total usage memory em MB by process name, like chrome, vim, etc
  memusage() {
    t=0;
    pids=$(pidof $1);
    for p in ${(ps: :)pids}; do
      cat /proc/$p/status \
        | grep -i vmrss \
        | awk '{print $2}';
    done \
      | while read m; do let t=$t+$m; echo $(($t/1024)); done \
      | tail -n1 \
      | xargs -I@ echo $1":" @ "MB"
  }

  dockermemusage() {
    for line in `docker ps \
      | awk '{print $1}' \
      | grep -v CONTAINER`; do
    docker ps | grep $line | awk '{printf $NF" "}' \
      && echo $(( `cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes` / 1024 / 1024 ))MB ;
  done
  }

  dockerstatus() {
    docker ps | awk '{if(NR>1) print $NF}'| xargs docker stats
  }

  dockerip() {
    for d in $(docker ps --format '{{.Names}}')
    do
      ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $d)
      printf "%s : %s\n" $d $ip
    done
  }

  copy(){ echo -n "$1" | xclip -selection clipboard }

  # function for QRCode
  [[ -f ~/.scripts/qrcode.sh ]]          && source ~/.scripts/qrcode.sh
  # function to backup histories
  [[ -f ~/.scripts/sync-histories.sh ]]  && source ~/.scripts/sync-histories.sh
  # function to connect throught VPN
  [[ -f ~/VPN/CyberGhost/vpn.sh  ]]      && source ~/VPN/CyberGhost/vpn.sh

  favicon() {
    # based on https://superuser.com/a/40629
    BASE=`basename "$1" .png`

    for size in {16,32,48,64}
    do
      echo "converting.. " "$size"x"$size"
      convert "$1" -thumbnail "$size"x"$size" "${BASE}_$size.png"
    done

    icotool -c -o "${BASE}.ico" "${BASE}"_{16,32,48,64}.png

    echo "removing >" "${BASE}"_{16,32,48,64}.png
    rm -f  "${BASE}"_{16,32,48,64}.png
  }
  # get battery whatts consumption
  # cat /sys/class/power_supply/BAT0/power_now | awk '{print $1*10^-6 " W"}'
fi

alias rodsFindDup="fd -tf . --print0 | xargs -0 sha1sum | sort | uniq -w40 --all-repeated=separate"
alias rodsvideo-720p="youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' --merge-output-format mkv -o '%(title)s.[ac.%(acodec)s].[vc.%(vcodec)s].%(ext)s' "
alias rodsvideo-1080p="youtube-dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' --merge-output-format mkv -o '%(title)s.[ac.%(acodec)s].[vc.%(vcodec)s].%(ext)s' "
alias vim="nvim"

# functions

bin2dec(){ echo "$((2#$1))" }

rodsTrueColor() {
  # https://gist.github.com/XVilka/8346728
  curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
}

rodsTestNerdFonts() {
  curl -s https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/bin/scripts/test-fonts.sh | bash
}

rodsCopyFromTo () {
  rsync -ai --chmod u=rw,go=r "$1" "$2" | pv -ls $(find "$1" -type f | wc -l) > /dev/null
}

rodsPipUpgrade () {
  sudo -H pip list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 sudo -H pip install -U
}

rodsPipOutdated () {
  sudo -H pip list --outdated --format=columns
}

weather () {
  WEATHER_URL="http://api.openweathermap.org/data/2.5/find?q=liberdade,br&APPID=3fa9fa72d3d8db1a0bf6b9383239faa7&units=metric"
  wget -qO- "${WEATHER_URL}" | python -m json.tool
}

rodsFTP () {
  currentIP=$(hostname -i | awk '{ print $1 }')
  echo $currentIP
  echo user: rods
  echo pass: 123
  sudo python -m pyftpdlib -w -p 21 -i $currentIP -u rods -P 123
}

# fv - open file in neovim
fv() {
  rg --files | fzf --bind 'enter:execute(nvim {1} < /dev/tty)'
}

# fgd - git diff not in stage
fgd() {
  git ls-files -m |
  fzf --ansi --sort --reverse --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (xargs -I % sh -c 'git diff %') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fdh - git diff HEAD~X..HEAD~Y
fdh() {
  git diff --name-only HEAD~$1..HEAD~$2 |
  fzf --ansi --sort --reverse --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (xargs -I % sh -c 'git diff HEAD~$1..HEAD~$2 %') << 'FZF-EOF'
                {}
FZF-EOF"
}
# fdbh = Fuzzy git Diff Branch..HEAD
fdbh() {
  branch="master"
  if [[ ! (-z $1) ]] then
    branch=$1
  fi

  git --no-pager diff --color=always --stat=120 $branch..\
    | fzf --ansi --multi --reverse --border \
    --header "[tab] select, [enter] diff
[ctrl+a] select all, [ctrl+x] deselect all" \
    --bind "ctrl-a:select-all,ctrl-x:deselect-all,esc:cancel" \
    --bind "enter:execute:
        (echo {+} | sed -E 's/\|[^+]+[-+]+//g' | sed -E 's/  +/ /g' | xargs git diff $branch.. ) << 'FZF-EOF'
FZF-EOF"
}

# fdc - git diff cached (in stage)
fdc() {
  git --no-pager diff --cached --name-only |
  fzf --ansi --sort --reverse --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (xargs -I % sh -c 'git diff --cached %') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux --reverse -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
# (including remote branches), sorted by most recent commit, limit 30 last branches
fco() {
  local tags branches target
  if [[ $1 = "-h" || $1 = "--help" ]]; then
    printf "usage: fco {args}\n\targs:\n"
    printf "\t%-17s \x1b[3 %s \x1b[0m\n" "--tags, -t" " include 'git tags' in result list"
    printf "\t%-17s \x1b[3 %s \x1b[0m\n" "--help, -h" " show this help"
    return 0
  fi
  if [[ $1 = "--tags" || $1 = "-t" ]]; then
    tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  fi

  branches=$(git branch --all --sort=-committerdate \
    | grep "remotes/" | grep -v HEAD \
    | sed 's/.* //' | sed "s#remotes/[^/]*/##" \
    | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  ) || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux --reverse -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# gbar - list 'git branch' by author, ordered by last commit date
# need vipe, nvim, easyalign
# brew install moreutils, neovim
# pacman -S moreutils, neovim
gbar() {
  for branch in `git branch -r \
    | grep -v HEAD`;do echo -e `git show --format="%ai %ar by %an" $branch \
    | head -n 1` \\t$branch; done \
    | sort -r \
    | EDITOR='nvim +:%EasyAlign/by/ +:%EasyAlign/\t/ +:%s/\t//g +:%s/\d\{2\}:.*00// +wq' vipe \
    | cat
}

# git branch parent, grabbed from https://gist.github.com/joechrysler/6073741
gbparent() {
  git show-branch -a 2>/dev/null \
    | grep '\*' \
    | grep -v `git rev-parse --abbrev-ref HEAD` \
    | head -n1 \
    | perl -ple 's/\[[A-Za-z]+-\d+\][^\]]+$//; s/^.*\[([^~^\]]+).*$/$1/'
  # branch=`git rev-parse --abbrev-ref HEAD`
  # git show-branch -a 2>/dev/null | grep '\*' | grep -v "$branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

# removes merged branches
# https://stackoverflow.com/a/38404202
gbprune() {
  git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
}

# removes merged and unmerged branches
# https://stackoverflow.com/a/38404202
gbprunef() {
  git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
fstash() {
  if [[ ("$1" == "-h") || ("$1" == "--help") ]]; then
    echo "
 --help, -h     show this help
 CTRL-A         apply a stash
 CTRL-D         shows a diff of the stash against your current HEAD
 CTRL-B         checks the stash out as a branch, for easier merging
 CTRL-S         shows the stash
"
    return 0
  fi

  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-a,ctrl-b,ctrl-d,ctrl-s);
  do
    IFS=$'\n'; set -f
    lines=($(<<< "$out"))
    unset IFS; set +f
    q="${lines[0]}"
    k="${lines[1]}"
    sha="${lines[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    case "$k" in
      ctrl-a)
        git stash apply $sha
      ;;
      ctrl-b)
        git stash branch "stash-$sha" $sha
        break;
      ;;
      ctrl-d)
        git diff $sha HEAD
      ;;
      ctrl-s)
        git -c color.ui=always stash show -p $sha | less -+F
      ;;
      *)
        echo "ctrl-a (apply), ctrl-b (branch), ctrl-d (diff), ctrl-s (show)"
      ;;
    esac
  done
}

# grabbed from https://gist.github.com/SlexAxton/4989674
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

# Easy extract one file from zip, rar, 7z files
7z1() {
  if [[ ! -z $1 ]] then
    # 7z l $1 | tail -n +19 | fzf --height 50% --reverse | awk '{$1=$2=$3=$4=$5=""; print $0}' | xargs -i{} 7z e $1 "{}"
    7z l $1 | rg "\d{4}-\d{2}-\d{2}" | awk '{$1=$2=$3=$5=""; print $0}' | fzf --height 50% --reverse | \
      awk '{$1=""; print $0}' | \
      xargs -i{} 7z e $1 "{}"
  else
    echo "invalid argument"
  fi
}

# tren: stands for Translate From ENglish, usage:
# tren he eats apples
tren() {
  trans -b en:pt "$*"
}

# trpt: stands for Translate From PorTugese, usage:
# trpt ele come maças
trpt() {
  trans -b pt:en "$*"
}

offScreen() {
  sleep 2 && xset -display :0.0 dpms force off
}

# from archwiki https://wiki.archlinux.org/index.php/Ranger
ranger() {
  if [ -z "$RANGER_LEVEL" ]; then
    /usr/bin/ranger "$@"
  else
    exit
  fi
}

setDns() {
  sudo resolvconf -x -a "wlp3s0.dhcp" < ~/.dnsservers
  resolvconf -l
}

pdfrange() {
  if [[ -z $1 ]]; then
    echo "usage:

      pdfrange file range

      $ pdfrange file.pdf 1-4
    "
    return 0
  fi

  basename=$(basename $1 .pdf)
  qpdf $1 --pages $1 $2 -- $(echo $basename"_out.pdf")
}

dec2hexTrans () {
  value=$( [[ -z $1 ]] && echo "50" || echo $1 )
  printf '%X\n' $(($value  * 255 / 100))
}

monitorNoteOff () {
  xrandr --output LVDS-0 --off; xrandr --output HDMI-0 --primary
}

monitorNoteOn () {
  xrandr --output LVDS-0 --auto; xrandr --output HDMI-0 --primary
}

# https://unix.stackexchange.com/questions/106375/make-zsh-alt-f-behave-like-emacs-alt-f
# bindkey '\ef' emacs-forward-word
# bindkey '\eb' emacs-backward-word
# commands apropos / search by commands

bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

