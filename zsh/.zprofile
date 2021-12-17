# startX right after TTY login
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx ~/.xinitrc
fi

#  PYTHON poetry
export PATH="$HOME/.poetry/bin:$PATH"

# PYTHON pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
