~/.screenlayout/stack.sh &

# Start tmux sessions if they don't already exist
tmux has-session -t dotfiles 2>/dev/null || tmux new-session -d -s dotfiles -c ~/.config/dotfiles
tmux has-session -t azile 2>/dev/null || tmux new-session -d -s azile -c ~/dev/azile
tmux has-session -t lazypm 2>/dev/null || tmux new-session -d -s lazypm -c ~/dev/lazypm

exec awesome
