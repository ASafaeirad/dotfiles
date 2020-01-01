#!/bin/bash

append_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/code
export TERM=xterm-256color
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/brave
export XDG_CONFIG_HOME="$HOME/.config"

[[ -f "$HOME/.aliases" ]] && . "$HOME/.aliases"

append_path "$HOME/.local/bin"

if test "$(yarn --version 2>/dev/null)"; then
  append_path "$HOME/.yarn/bin"
  append_path "$HOME/.config/yarn/global/node_modules/.bin"
fi

if test "$(go version 2>/dev/null)"; then
  export GOPATH=$HOME/go
fi
