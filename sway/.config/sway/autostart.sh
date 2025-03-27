#!/bin/bash

# # Start GNOME Keyring
# eval $(gnome-keyring-daemon --start)
# export SSH_AUTH_SOCK

# # Start Polkit authentication agent (only if not already running)
# if ! pgrep -f polkit-gnome-authentication-agent-1 > /dev/null; then
#     # Start Polkit authentication agent
#     /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# fi

# # Start XDG Desktop Portal
# systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
# systemctl --user start xdg-desktop-portal.service

# ================================================================================

# Start GNOME settings daemon
/usr/lib/gsd-xsettings &

# Start GNOME Shell in headless mode
dbus-run-session -- gnome-shell --mode=headless --wayland --no-x11 &

# Wait for GNOME Shell to initialize
sleep 3

# Export GNOME session environment variables
export GNOME_SHELL_SESSION_MODE=wayland
export GNOME_SETUP_DISPLAY=1

# Start required GNOME services
/usr/lib/gnome-session-binary --systemd-service --session=gnome-wayland &
