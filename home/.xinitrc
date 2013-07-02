#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

export LANG=en_US.UTF-8

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrandr --output LVDS1 --mode 1280x800 --pos 0x0 --primary --output VGA1 --mode 1680x1050 --pos 1280x0

# Consistent clipboard
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# Use X resources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec sh ~/.fehbg &
# Start window manager
exec i3
exec dropboxd&
