#!/bin/sh

#clangd
sudo apt-get -y install clangd

#clang-format
sudo apt install clang-format
 
#tmux
sudo apt install tmux -y
cp ~/.config/dotfiles/.tmux.conf ~/
#tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#starship
curl -sS https://starship.rs/install.sh | sh
cp ~/.config/dotfiles/starship.toml ~/.config/

# alacritty
git clone https://github.com/alacritty/alacritty.git ~/repos/alacritty
cd ~/repos/alacritty
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
cd ~/.config/dotfiles
cp -r ~/.config/dotfiles/alacritty/ ~/.config/

#eza
git clone https://github.com/eza-community/eza.git ~/repos/eza
cd ~/repos/eza
cargo install --path .
cd ~/.config/dotfiles

# NVM (node version manager)
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
exec zsh
cd ~/.config/dotfiles
nvm install node

# rg
sudo apt-get install ripgrep -y

# fd
cargo install fd-find

#stylua
cargo install stylua

#brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

#pulseaudio
sudo apt install pulseaudio -y

#pavucontrol
sudo apt-get install pavucontrol -y


#vlc
sudo apt install vlc -y

#arandr
sudo apt install arandr -y

#docker

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#docker desktop
cd ~/Downloads/
curl -O https://desktop.docker.com/linux/main/amd64/docker-desktop-4.25.2-amd64.deb
sudo apt-get install ./docker-desktop-4.25.2-amd64.deb -y
cd ~/.config/dotfiles

#neovim
mkdir ~/repos/nvim
cd ~/repos/nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
sudo ln -s ~/repos/nvim/squashfs-root/AppRun /usr/bin/nvim
cd ~/.config/dotfiles/
cp -r ~/.config/dotfiles/nvim/ ~/.config/

#awesomewm
sudo apt-get install awesome
cp -r ~/.config/dotfiles/awesome/ ~/.config/

# install nerdfont
sudo cp -r ~/.config/dotfiles/fonts/saucecodepro/ /usr/share/fonts/truetype

sudo reboot
