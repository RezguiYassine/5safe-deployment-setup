#! /run/current-system/sw/bin/sh
colorBg=$1
colorFg=$2
colorFocus=$3
colorSecondary=$4

picom --animations --animation-window-mass 1 --animation-for-open-window zoom --animation-stiffness 200 --experimental-backends & # requires picom-pijulius
# alttab -w 1 -t 240x160 -i 64x64 -sc 1 -bg $colorBg -fg $colorFg -frame $colorSecondary -inact $colorFg &
##/usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --height 28 --tint $trayertint --monitor "primary" &
# nm-applet &
# GOMAXPROCS=1 syncthing --no-browser &
# gnome-keyring-daemon --daemonize --login &
# gnome-keyring-daemon --start --components=secrets &
