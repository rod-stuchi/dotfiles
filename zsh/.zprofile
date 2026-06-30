# vim: fdm=marker foldcolumn=3 et ts=2 sts=2 sw=2 ai relativenumber number ft=sh
if [[ "$(uname)" == "Linux" ]]; then
    if [[ -z "$WAYLAND_DISPLAY" ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && [[ -z "$NIRI_LAUNCHED" ]]; then
        # niri-session re-execs the login shell (`exec -l "$SHELL" -c '... -l'`) to
        # guarantee a login environment, which re-sources this file. Without this
        # sentinel that re-source would hit the VT1 condition again and exec
        # niri-session a second time -> infinite loop (tty1 hangs forever).
        export NIRI_LAUNCHED=1

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

        # use ibus for GTK and QT applications
        export GTK_IM_MODULE=ibus
        export QT_IM_MODULE=ibus
        export XMODIFIERS=@im=ibus

        # hyprland ========================
        # exec hyprland
        # hyprland ========================

        # Start niri as a systemd user service (niri.service). This brings up
        # graphical-session.target and pulls in everything under
        # ~/.config/systemd/user/niri.service.wants/ (mako, waybar, swayidle,
        # qpwgraph, ssh-agent, ...). niri-session imports the environment into
        # systemd/D-Bus itself, so no separate dbus-update line is needed.
        # Redirect niri-session's own output (import-environment / LESS_TERMCAP
        # warnings, etc.) to a log file so tty1 stays clean. niri's compositor logs
        # are unaffected (journalctl --user -u niri.service). `>` truncates each
        # login, so the log always reflects the latest session.
        mkdir -p "$HOME/.local/state/niri"
        exec niri-session >"$HOME/.local/state/niri/session.log" 2>&1

        # Fallback: launch niri directly (does NOT start niri.service / the
        # graphical-session target, so niri.service.wants is ignored).
        # exec niri --session

    fi
fi

if [[ "$(uname)" == "Darwin" ]]; then
    # loads homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

