#!/bin/bash
#
# dvolbar - OSD Volume utility
#

#Customize this stuff
IF="Master"         # audio channel: Master|PCM
SECS="1"            # sleep $SECS
BG="#111111"        # background colour of window
FG="#eeeeee"        # foreground colour of text/icon
BAR_FG="#ffffff"    # foreground colour of volume bar
BAR_BG="#777777"    # background colour of volume bar
XPOS="705"          # horizontal positioning
YPOS="500"          # vertical positioning
HEIGHT="30"         # window height
WIDTH="250"         # window width
BAR_WIDTH="165"     # width of volume bar
ICON=~/vol-hi.xbm
FONT="-*-terminus-medium-r-*-*-14-*-*-*-*-*-*-*"
ICON_VOL=~/vol-hi.xbm
ICON_VOL_MUTE=~/vol-mute.xbm
ICON=$ICON_VOL

# Lets find the appropriate positioning for the volume bar
XRES=`xdpyinfo|grep 'dimensions:'|awk '{print $2}'|cut -dx -f1`
XPOS=$[$XRES / 2 - $WIDTH / 2]          # horizontal positioning
YRES=`xdpyinfo|grep 'dimensions:'|awk '{print $2}'|cut -dx -f2`
YPOS=$[$YRES * 4 / 5]          # vertical positioning

#Probably do not customize
PIPE="/tmp/dvolpipe"

err() {
  echo "$1"
  exit 1
}

usage() {
  echo "usage: dvol [option] [argument]"
  echo
  echo "Options:"
  echo "     -i, --increase - increase volume by \`argument'"
  echo "     -d, --decrease - decrease volume by \`argument'"
  echo "     -t, --toggle   - toggle mute on and off"
  echo "     -h, --help     - display this"
  exit
}

#Argument Parsing
case "$1" in
  '-i'|'--increase')
    [ -z "$2" ] && err "No argument specified for increase."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%+"
    ;;
  '-d'|'--decrease')
    [ -z "$2" ] && err "No argument specified for decrease."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%-"
    ;;
  '-t'|'--toggle')
    AMIXARG="toggle"
    ;;
  ''|'-h'|'--help')
    usage
    ;;
  *)
    err "Unrecognized option \`$1', see dvol --help"
    ;;
esac

#Actual volume changing (readability low)
AMIXOUT="$(amixer set "$IF" "$AMIXARG" | tail -n 1)"
MUTE="$(cut -d '[' -f 4 <<<"$AMIXOUT")"
VOL="$(cut -d '[' -f 2 <<<"$AMIXOUT" | sed 's/%.*//g')"
if [ "$MUTE" = "off]" ]; then
  ICON=$ICON_VOL_MUTE
else
  ICON=$ICON_VOL
fi

#Using named pipe to determine whether previous call still exists
#Also prevents multiple volume bar instances
if [ ! -e "$PIPE" ]; then
  mkfifo "$PIPE"
  (dzen2 -tw "$WIDTH" -h "$HEIGHT" -x "$XPOS" -y "$YPOS" -fn "$FONT" -bg "$BG" -fg "$FG" < "$PIPE"
   rm -f "$PIPE") &
fi

#Feed the pipe!
(echo "$VOL" | gdbar -l "^i(${ICON})" -fg "$BAR_FG" -bg "$BAR_BG" -w "$BAR_WIDTH" ; sleep "$SECS") > "$PIPE"
