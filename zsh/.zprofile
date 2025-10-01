# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh
if [[ "$(uname)" == "Linux" ]]; then
    if [[ -z "$WAYLAND_DISPLAY" ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        # rfkill unblock all

        # update dbus address for interaction with AwesomeWM
        # /home/rods/develop/playwright/xe.com/update_dbus_address.sh &

        # update dbus address for needed scripts
        # /home/rods/.scripts/update_dbus_addresses.sh

        # {{{ SWAY / Wayland
        # export GTK_IM_MODULE=cedilla
        # export QT_IM_MODULE=cedilla
        export QT_QPA_PLATFORM=wayland
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_WEBRENDER=1

        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        # export TERM=wezterm
        # export TERMINAL=wezterm
        export CHROME_OZONE_PLATFORM_HINT=auto
        ### export XDG_SESSION_DESKTOP=niri


        # this is for LibreOffice that uses VCL (Visual Class Library)
        export SAL_USE_VCLPLUGIN=qt6

        export QT_STYLE_OVERRIDE=kvantum


        # this is working great with Ghostty termianl when opening two or more tabs.
        # https://github.com/vinceliuice/Orchis-theme
        export GTK_THEME=Orchis-Dark-Compact

        export XDG_PICTURES_DIR=$HOME/tmp/screenshots

        # hyprland ========================
        # exec hyprland
        # hyprland ========================


        # exec niri --session
        # Start niri with proper dbus session
        exec dbus-run-session niri --session

    fi
fi

if [[ "$(uname)" == "Darwin" ]]; then
    # loads homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

