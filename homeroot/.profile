# PYTHON pyenv
# TODO: remove PYENV, use UV instead.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export EDITOR=nvim
# TODO: check if this variable is required
export RODS=dotprofile
. "$HOME/.cargo/env"

# by tzselect
TZ='America/Sao_Paulo'; export TZ
. "/home/rods/.deno/env"
. "$HOME/.local/bin/env"
