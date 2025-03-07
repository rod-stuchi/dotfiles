#  PYTHON poetry
export PATH="$HOME/.poetry/bin:$PATH"

# PYTHON pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export EDITOR=nvim
export RODS=dotprofile
. "$HOME/.cargo/env"

# by tzselect
TZ='America/Sao_Paulo'; export TZ
. "/home/rods/.deno/env"
. "$HOME/.local/bin/env"
