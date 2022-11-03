# startX right after TTY loginZDOTDIR
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx ~/.xinitrc
fi

eval "$(pyenv init --path)"
