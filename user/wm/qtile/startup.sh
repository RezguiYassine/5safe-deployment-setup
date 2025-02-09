#! /run/current-system/sw/bin/sh
start_if_not_running() {
  if ! pgrep -x "$1" > /dev/null; then
    $2 &
  else
    echo "$1 is already running"
  fi
}
~/.fehbg-stylix
start_if_not_running "blueman-applet" "blueman-applet"
start_if_not_running "pasystray" "pasystray"
start_if_not_running "nm-applet" "nm-applet"
# GOMAXPROCS=1 syncthing --no-browser &
# gnome-keyring-daemon --daemonize --login &
# gnome-keyring-daemon --start --components=secrets &
