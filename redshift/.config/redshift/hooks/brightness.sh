#!/bin/sh
# ref: https://wiki.archlinux.org/title/redshift

# Set brightness via xbrightness when redshift status changes

# Set brightness values for each status.
# Range from 1 to 100 is valid
brightness_day=100
brightness_transition=50
brightness_night=5
# Set fps for smoooooth transition
fps=1000

# Adjust this grep to filter only the backlights you want to adjust
# backlights=($(xbacklight -list | grep ddcci*))

set_brightness() {
    # for backlight in "${backlights[@]}"
    # do
    #     xbacklight -set $1 -fps $fps -ctrl $backlight &
    #     ddcutil setvcp 10 $1
    # done

    # laptop screen
    xbacklight -set $1 -fps $fps -ctrl "intel_backlight" &
    # lg screen
    ddcutil setvcp 10 $1 & 
}

dunstify "redshift 🌆 : $1 : $3"
if [ "$1" = period-changed ]; then
    case $3 in
        night)
            set_brightness $brightness_night 
            echo $brightness_night > /tmp/brightness_state
            ;;
        transition)
            set_brightness $brightness_transition
            echo $brightness_transition > /tmp/brightness_state
            ;;
        daytime)
            set_brightness $brightness_day
            echo $brightness_day > /tmp/brightness_state
            ;;
    esac
fi
