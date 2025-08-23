link_file() {
    local source=$1
    local dest=$2

    if [ -z "$source" ] || [ -z "$dest" ]; then
        echo "Usage: link_file <source> <dest>"
        return 1
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Removing existing $dest"
        rm -rf "$dest"
    fi

    ln -s "$source" "$dest"
    echo "Created symlink: $dest -> $source"
}

# file symlinks
link_file "$HOME/.config/dotfiles/.asoundrc" "$HOME/.asoundrc"
link_file "$HOME/.config/dotfiles/.xinitrc" "$HOME/.xinitrc"
link_file "$HOME/.config/dotfiles/.bashrc" "$HOME/.bashrc"
link_file "$HOME/.config/dotfiles/.bash_profile" "$HOME/.bash_profile"
link_file "$HOME/.config/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
link_file "$HOME/.config/dotfiles/.gitconfig" "$HOME/.gitconfig"
link_file "$HOME/.config/dotfiles/spotify-player/app.toml" "$HOME/.config/spotify-player/app.toml"
link_file "$HOME/.config/dotfiles/st/config.h" "$HOME/tools/st/config.h"
link_file "$HOME/.config/dotfiles/.screenlayout/layout.sh" "$HOME/.screenlayout/layout.sh"
link_file "$HOME/.config/dotfiles/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

# dir symlinks
link_file "$HOME/.config/dotfiles/nvim" "$HOME/.config/nvim"
link_file "$HOME/.config/dotfiles/awesome" "$HOME/.config/awesome"
