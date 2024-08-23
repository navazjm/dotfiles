export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:/opt/homebrew/opt/postgresql@15/bin
# export PATH=$PATH:/Users/michaelnavarro/repos/tloc/build/tloc

# zsh specific
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
plugins=(
  git
  sudo
  copypath
  copyfile
  copybuffer
)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#shell prompt
eval "$(starship init zsh)"

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
alias gplr="git pull --rebase"
alias gf="git fetch"
alias gd="git diff"
alias gm="git merge"
alias gmnff="git merge --no-ff"
alias gr="git rebase"
alias gst="git stash"

alias cl="clear"
alias ..="cd .."

alias n="nvim"
alias t="tmux"
