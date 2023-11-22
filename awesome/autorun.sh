#!/usr/bin/bash

# Launch Apps when AwesomeWM starts.

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

# List the apps you wish to run on startup below preceded with "run"

# Policy kit (needed for GUI apps to ask for password)
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# xrandr layout for AwesomeWM
run ~/.config/awesome/.scripts/awesome_display_layout.sh &
