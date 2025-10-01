#!/usr/bin/env bash

# ref: https://gist.github.com/Ar7eniyan/42567870ad2ce47143ffeb41754b4484
#
receive_pipe="/tmp/waybar-ddc-backlight-rx"
step=5

ddcutil_fast() {
    # adjust the bus number and the multiplier for your display
    # multiplier should be chosen so that it both works reliably and fast enough
    ddcutil --noverify --bus 9 --sleep-multiplier .03 "$@" 2>/dev/null
}

ddcutil_slow() {
    ddcutil --maxtries 15,15,15 "$@" 2>/dev/null
}

# takes ddcutil commandline as arguments
print_brightness() {
    if brightness=$("$@" -t getvcp 10); then
        brightness=$(echo "$brightness" | cut -d ' ' -f 4)
    else
        brightness=-1
    fi
    echo '{ "percent":' "$brightness" '}'
}

rm -rf $receive_pipe
mkfifo $receive_pipe

# in case waybar restarted the script after restarting/replugging a monitor
print_brightness ddcutil_slow

while true; do
    read -r command < $receive_pipe
    case $command in
        + | -)
            ddcutil_fast setvcp 10 $command $step
            ;;
        max)
            ddcutil_fast setvcp 10 100 
            ;;
        min)
            ddcutil_fast setvcp 10 2
            ;;
    esac
    print_brightness ddcutil_fast
done
