# startX right after TTY loginZDOTDIR
# if [ -x "$(command -v systemctl)" ]; then
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx ~/.xinitrc
fi
# else
#     echo '⚠️ systemctl is not installed.' >&2
# fi

# if [ -x "$(command -v pyenv)" ]; then
eval "$(pyenv init --path)"
# else
#     echo '⚠️ pyenv is not installed.' >&2
# fi
