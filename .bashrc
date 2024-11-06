export PATH="$PATH:$HOME/.cargo/bin"

# Aliases to replace ls with eza
alias ls='eza -la'
alias la='eza -la --grid'

# Other aliases
alias cl='clear'
alias ..='cd ..'

# Aliases for editing configuration files
alias nb='nvim ~/.bashrc'
alias nk='nvim ~/.config/kitty/kitty.conf'
alias nn='nvim ~/.config/nvim/init.lua'
alias nt='nvim ~/.tmux.conf'

export PS1='$(azile) '
# Custom prompt function to call azile (if needed)
# function prompt_command() {
#     
# }
# PROMPT_COMMAND=prompt_command
source ~/.local/share/blesh/ble.sh
source /usr/share/nvm/init-nvm.sh
