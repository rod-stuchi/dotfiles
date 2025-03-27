#!/bin/bash

swaymsg reload
swaymsg output eDP-1 enable
swaymsg output eDP-1 power on
swaymsg output eDP-1 mode 1920x1080@143.998Hz pos 0 0
swaymsg output DP-1 enable
swaymsg output DP-1 power on
swaymsg output DP-1 mode 3440x1440@99.997Hz pos 1920 0
