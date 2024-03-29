#!/bin/sh

# install dependencies needed for ./install.sh

mkdir ~/repos/

sudo apt update
sudo apt install build-essential -y
sudo apt install curl -y

sudo apt install git -y
git config --global user.name "navazjm"
#git config --global user.email "email@email.com"

# zsh, oh-my-zsh, zsh-autosuggestions
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp ~/.config/dotfiles/.zshrc ~/

# make zsh default shell
chsh -s $(which zsh)

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# go
sudo rm -rf /usr/local/go
cd ~/Downloads/
curl -LJO https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
cd ~/.config/dotfiles

# open zsh shell inside bash shell
zsh
