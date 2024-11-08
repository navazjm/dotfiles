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

# starship init fish | source

function fish_prompt
    /usr/local/bin/azile
    echo -n ' '
end

# set -gx AZILE_PROMPT_END_SYMBOL '$'

# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
