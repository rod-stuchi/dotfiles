(rm ~/.__localstate 2> /dev/null) &

# https://github.com/dunst-project/dunst/issues/1112#issuecomment-1254645747
systemd --user import-environment DISPLAY XAUTHORITY &
# https://github.com/dunst-project/dunst/issues/633#issuecomment-495992147
export $(dbus-launch)

# update dbus address for interaction with AwesomeWM
/home/rods/develop/playwright/xe.com/update_dbus_address.sh &

# display settings
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96

# kde apps
# kglobalaccel5 &

# turn on nulock
(sleep 5 && numlockx on) &
# sleep 7 && pkill -SIGRTMIN+11 i3blocks &


# turn off monitor in 5 minutes
xset dpms 0 300 400 &
# disable screen saver
xset s off &

xrandr | rg --quiet "DP-0 connected"
if [ $? = 0 ]; then
    # sleep 1 && xrandr --output eDP-1-1 --auto --right-of HDMI-0 --output HDMI-0 --primary &
    sleep 1 && xrandr --output eDP-1-1 --auto --left-of DP-0 --output DP-0 --primary &
else
    sleep 1 && xrandr --output eDP-1-1 --primary &
fi

# for transparency
# picom --config ~/.config/picom/picom.conf &

# enable pulseaudio at start
# sleep 5 && systemctl --user restart pulseaudio.service && notify-send -t 500 -u low "pulseaudio OK" &
# sleep 6 && pkill -SIGRTMIN+10 i3blocks &

# pipewire / easyeffects
easyeffects --gapplication-service &

# lock-screen
xss-lock --transfer-sleep-lock -- zsh ~/.scripts/lock-screen.zsh &

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


sxhkd &

# wallpapers
(sleep 4 && zsh ~/.scripts/wallpaper.zsh) &

# exec startkde
# exec /usr/bin/startplasma-x11
# exec dwm
# exec i3
exec awesome

# xinput disable "UNIW0001:00 093A:1336 Touchpad" # disabled via modprobe blacklist
