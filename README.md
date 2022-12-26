<!-- PROJECT LOGO -->
<br />
<p align="center">
  <img src="https://michaelnavs-readme.s3.us-east-2.amazonaws.com/dotfiles.png" alt="Logo" width="80">

  <h3 align="center">Dotfiles</h3>

  <p align="center">
  The dotfiles for all the tools and programs I use
  </p>
</p>

## Installation

```sh
cd ~/.config
```

```sh
git clone https://github.com/michaelnavs/config.git .
```

## Main Tools Used

### Terminal Tools
- Terminal Emulator => [Kitty](./kitty/kitty.conf)
- Prompt => [Starship](./starship.toml)
- Multiplexer => [Tmux](./.tmux.conf)
- Shell => [ZSH](./.zshrc)

### Text Editor / IDE
- [Neovim](./nvim/init.lua)

### Window Manager
- MacOS Tiling Window Manager => [Yabai](./yabairc)
- Keyboard Customizer => [Karabiner](./karabiner/karabiner.json)
- Configure Hotkeys => [SKHD](./.skhdrc)


## After updating macOS or restarting machine

```sh
sudo yabai --load-sa
```

```sh
brew services restart yabai
```

```sh
brew services restart skhd
```
