#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers-3440x1440"
CURRENT_FILE="$HOME/.config/sway/current-wallpaper"

# Get all wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

# Read current wallpaper index
if [[ -f "$CURRENT_FILE" ]]; then
    CURRENT_INDEX=$(cat "$CURRENT_FILE")
else
    CURRENT_INDEX=0
fi

# Get next wallpaper
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Save current index
echo "$NEXT_INDEX" > "$CURRENT_FILE"

# Change wallpaper
swaymsg output "*" bg "$WALLPAPER" fill

# Notify user
dunstify "Wallpaper Changed" "$(basename "$WALLPAPER")"
