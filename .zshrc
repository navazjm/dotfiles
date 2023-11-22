PATH=$PATH:~/.cargo/bin
PATH=$PATH:/usr/local/go/bin

# export QT_QPA_PLATFORMTHEME="qt5ct"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

plugins=(
  git
  sudo
  zsh-autosuggestions
  copypath
  copyfile
  copybuffer
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# needed for neovim lspconfig clangd
export CPLUS_INCLUDE_PATH=/usr/include/c++/11:/usr/include/x86_64-linux-gnu/c++/11

# export MCFLY_DISABLE_MENU=TRUE
# export MCFLY_LIGHT=TRUE
# export MCFLY_KEY_SCHEME=vim
# export MCFLY_RESULTS_SORT=LAST_RUN
# export MCFLY_RESULTS=25
# export MCFLY_FUZZY=5
# source <(mcfly init zsh)

alias ls="eza -la"
alias la="eza -la --grid"

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
