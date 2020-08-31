#!/bin/zsh

. ${XDG_CONFIG_HOME:-$HOME/.config}/env

[ "$(tty)" = "/dev/tty1" ] && ! pidof Xorg >/dev/null 2>&1  && exec startx

# Switch escape and caps if tty and no passwd required:
sudo -n loadkeys ${XDG_DATA_HOME:-$HOME/.local/share}/rewire/ttymaps.kmap 2>/dev/null

