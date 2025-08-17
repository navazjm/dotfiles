#!/usr/bin/env bash

~/.screenlayout/layout.sh &

# Start tmux sessions if they don't already exist
tmux has-session -t dotfiles 2>/dev/null || tmux new-session -d -s dotfiles -c ~/.config/dotfiles
tmux has-session -t azile 2>/dev/null || tmux new-session -d -s azile -c ~/dev/azile
tmux has-session -t lazypm 2>/dev/null || tmux new-session -d -s lazypm -c ~/dev/lazypm
tmux has-session -t spotify_player 2>/dev/null || tmux new-session -d -s spotify_player
tmux has-session -t remembrall 2>/dev/null || tmux new-session -d -s remembrall -c ~/dev/remembrall

export XCURSOR_SIZE=14

exec awesome
