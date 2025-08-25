#!/usr/bin/env bash

## I use Arandr to set display orientations and positions and save it to 
## ~/.screenlayout/arandr.sh.
## I will then copy the output, mode, pos, and rotate to this file.
## This script is called in ~/.xinitrc

xrandr --dpi 130 \
    --output DisplayPort-0 --rate 239.97 --primary \
    --mode 2560x1440 --pos 0x0 --rotate normal  \
