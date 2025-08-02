#!/usr/bin/env bash

# swaylock -f -c $($HOME/.config/sway/random-color.sh)
color_bg=$($HOME/.config/sway/random-color.sh | tr -d "#")
inside_color=$(echo "$color_bg" | pastel complement | pastel format hex | tr -d '#')
ring_color=$(echo "$inside_color" | pastel darken 0.25 | pastel format hex | tr -d '#')
ring_ver_color=$(echo "$ring_color" | pastel complement | pastel format hex | tr -d '#')

ring_color__light=$(echo "$ring_color" | pastel lighten 0.1 | pastel format hex | tr -d '#')
ring_color__dark=$(echo "$ring_color" | pastel darken 0.2 | pastel format hex | tr -d '#')

# echo color_bg "$color_bg"; pastel color $color_bg | pastel format
# echo inside_color "$inside_color"; pastel color $inside_color | pastel format
# echo ring_color "$ring_color"; pastel color $ring_color | pastel format
# echo ring_ver_color "$ring_ver_color"; pastel color $ring_ver_color | pastel format

swaylock -F -f \
    -c "$color_bg" \
    --inside-color "$inside_color" \
    --ring-color "$ring_color" \
    --ring-ver-color "$ring_ver_color" \
    --key-hl-color "$inside_color" \
    --separator-color "$inside_color" \
    --layout-bg-color "$ring_color__dark" \
    --layout-border-color "$ring_color" \
    --layout-text-color "$color_bg" \
    -r
