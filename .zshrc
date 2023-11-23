PATH=$PATH:~/.cargo/bin
PATH=$PATH:/usr/local/go/bin

# export QT_QPA_PLATFORMTHEME="qt5ct"

# zsh specific
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
plugins=(
  git
  sudo
  zsh-autosuggestions
  copypath
  copyfile
  copybuffer
)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

#shell prompt
eval "$(starship init zsh)"

# needed for neovim lspconfig clangd
export CPLUS_INCLUDE_PATH=/usr/include/c++/11:/usr/include/x86_64-linux-gnu/c++/11
 
#mcfly
# export MCFLY_DISABLE_MENU=TRUE
# export MCFLY_LIGHT=TRUE
# export MCFLY_KEY_SCHEME=vim
# export MCFLY_RESULTS_SORT=LAST_RUN
# export MCFLY_RESULTS=25
# export MCFLY_FUZZY=5
# source <(mcfly init zsh)

#nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#replace ls with eza
alias ls="eza -la"
alias la="eza -la --grid"

#git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gp="git push"
alias gpl="git pull"
alias gf="git fetch"
alias gd="git diff"

alias cl="clear"
alias ..="cd .."

alias n="nvim"
alias t="tmux"
