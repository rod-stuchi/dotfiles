# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh
if [[ "$(uname)" == "Linux" ]]; then
    if [[ -z "$WAYLAND_DISPLAY" ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        # rfkill unblock all

        # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
        # dbus-update-activation-environment WAYLAND_DISPLAY
        # dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

        # === This is to open file picker in Google Chrome ===
        # # https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
        # https://bbs.archlinux.org/viewtopic.php?pid=2161602#p2161602
        # source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
        # systemctl --user import-environment DISPLAY XAUTHORITY 
        # systemctl --user restart xdg-desktop-portal-gtk


        # https://github.com/dunst-project/dunst/issues/633#issuecomment-495992147
        # export $(dbus-launch)

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
        # export TERM=wezterm
        # export TERMINAL=wezterm
        export XDG_SESSION_TYPE=wayland
        export CHROME_OZONE_PLATFORM_HINT=wayland
        # export XDG_CURRENT_DESKTOP=sway
        export QT_STYLE_OVERRIDE=kvantum
        export GTK_THEME=Orchis-Dark-Compact
        export XDG_PICTURES_DIR=$HOME/tmp/screenshots

        # for nvidia support
        # export WLR_NO_HARDWARE_CURSORS=1
        # }}}

        # sway ============================
        # exec >> /tmp/sway.log 2>&1
        # to run with Nvidia
        # exec sway --unsupported-gpu
        # to run without Nvidia
        # exec sway
        # sway ============================

        # hyprland ========================
        # exec hyprland
        # hyprland ========================

        exec niri --session
        # niri --session

        # kde =============================
        # to start plasma / kde
        # exec startplasma-wayland
        # kde =============================
    fi
fi

if [[ "$(uname)" == "Darwin" ]]; then
    # loads homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

