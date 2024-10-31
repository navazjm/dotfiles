fish_add_path ~/.cargo/bin
fish_add_path /opt/homebrew/opt/postgresql@15/bin
fish_add_path /Applications/Docker.app/Contents/Resources/bin
fish_add_path /opt/homebrew/opt/llvm/bin

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set -g fish_cursor_default block
# Set the insert mode cursor to a line
set -g fish_cursor_insert line
# Set the replace mode cursors to an underscore
set -g fish_cursor_replace_one underscore
set -g fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set -g fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set -g fish_cursor_visual block
# enabled vim keybindings
set -g fish_key_bindings fish_vi_key_bindings

# replace ls with eza
abbr -a ls eza -la
abbr -a la eza -la --grid

abbr -a cl clear
abbr -a .. cd ..

abbr -a nf nvim ~/.config/fish/config.fish
abbr -a nk nvim ~/.config/kitty/kitty.conf
abbr -a nn nvim ~/.config/nvim/init.lua
abbr -a nt nvim ~/.tmux.conf

# function fish_prompt
#     /usr/local/bin/azile
# end
