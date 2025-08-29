#!/usr/bin/env bash

# apply monitor(s) layout
~/.screenlayout/layout.sh &

# Start tmux sessions if they don't already exist
tmux has-session -t dotfiles 2>/dev/null || tmux new-session -d -s dotfiles -c ~/.config/dotfiles
tmux has-session -t azile 2>/dev/null || tmux new-session -d -s azile -c ~/dev/azile
tmux has-session -t lazypm 2>/dev/null || tmux new-session -d -s lazypm -c ~/dev/lazypm
tmux has-session -t spotify_player 2>/dev/null || tmux new-session -d -s spotify_player
tmux has-session -t remembrall 2>/dev/null || tmux new-session -d -s remembrall -c ~/dev/remembrall

# trigger xsecurelock after 5 minutes -- screenlock -> ~/.local/bin/screenlock
xautolock -time 5 -locker screenlock -detectsleep &

export XCURSOR_SIZE=14
exec awesome
