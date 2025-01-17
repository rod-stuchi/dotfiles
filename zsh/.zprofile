# if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
if [[ -z "$WAYLAND_DISPLAY" ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    # rfkill unblock all

    # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
    # dbus-update-activation-environment WAYLAND_DISPLAY
    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

    # # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
    # systemd --user import-environment DISPLAY XAUTHORITY &
    #
    # https://github.com/dunst-project/dunst/issues/633#issuecomment-495992147
    export $(dbus-launch)

    # update dbus address for interaction with AwesomeWM
    # /home/rods/develop/playwright/xe.com/update_dbus_address.sh &

    exec sway
fi

# startX right after TTY loginZDOTDIR
# if [ -x "$(command -v systemctl)" ]; then
# if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#     exec startx ~/.xinitrc
# fi
# else
#     echo '⚠️ systemctl is not installed.' >&2
# fi


# if [ -x "$(command -v pyenv)" ]; then
# eval "$(pyenv init --path)"
# else
#     echo '⚠️ pyenv is not installed.' >&2
# fi

