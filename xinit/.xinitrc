# display settings
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96

# kde apps
# kglobalaccel5 &

# turn on nulock
sleep 5 && numlockx on &
sleep 7 && pkill -SIGRTMIN+11 i3blocks &


# turn off monitor in 5 minutes
xset dpms 0 300 400 &
# disable screen saver
xset s off &

xrandr | rg --quiet "HDMI-0 connected"
if [ $? = 0 ]; then
    sleep 1 && xrandr --output eDP-1-1 --auto --right-of HDMI-0 --output HDMI-0 --primary &
else
    sleep 1 && xrandr --output eDP-1-1 --primary &
fi

# wallpapers
(sleep 1 &&  zsh ~/.scripts/wallpaper.zsh) &

# for transparency
picom --config ~/.config/picom/picom.conf &

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

rm ~/.__localstate &> /dev/null

sxhkd &

# exec startkde
# exec /usr/bin/startplasma-x11
# exec i3
# exec dwm
exec awesome

# xinput disable "UNIW0001:00 093A:1336 Touchpad" # disabled via modprobe blacklist
