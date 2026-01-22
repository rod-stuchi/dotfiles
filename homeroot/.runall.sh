#!/usr/bin/env bash

$HOME/.scripts/cycle-wallpaper-niri.sh &
/usr/bin/qpwgraph -m &
systemctl --user start mako.service &
systemctl --user start swayidle.service &
systemctl --user start ssh-agent.service &
(sleep 2 && /usr/bin/waybar) &
