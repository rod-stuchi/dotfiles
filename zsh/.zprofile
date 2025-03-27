if [[ "$(uname)" == "Linux" ]]; then
    if [[ -z "$WAYLAND_DISPLAY" ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        # rfkill unblock all

        # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
        # dbus-update-activation-environment WAYLAND_DISPLAY
        dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

        # # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
        # systemd --user import-environment DISPLAY XAUTHORITY &


        # https://github.com/dunst-project/dunst/issues/633#issuecomment-495992147
        export $(dbus-launch)

        # update dbus address for interaction with AwesomeWM
        # /home/rods/develop/playwright/xe.com/update_dbus_address.sh &

        # update dbus address for needed scripts
        /home/rods/.scripts/update_dbus_addresses.sh

        exec sway
        # exec >> /tmp/sway.log 2>&1
        # sway

        # to start plasma / kde
        # exec startplasma-wayland
    fi
fi

if [[ "$(uname)" == "Darwin" ]]; then
    # loads homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

