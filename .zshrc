export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:/opt/homebrew/opt/postgresql@15/bin
export PATH=$PATH:/Applications/Docker.app/Contents/Resources/bin
export PATH=$PATH:/opt/homebrew/opt/llvm/bin

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
    zsh-vi-mode
)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#oh-my-posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/dotfiles/theme.omp.toml)"
fi

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#replace ls with eza
alias ls="eza -lahF --icons --classify"
alias lsr="ls -RT"
alias la="ls --grid"

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

alias con="cd ~/.config"
alias dot="cd ~/.config/dotfiles"
alias nk="nvim ~/.config/kitty/kitty.conf"
alias nn="nvim ~/.config/nvim/init.lua"
alias nt="nvim ~/.tmux.conf"
alias nz="nvim ~/.zshrc"

alias ac="$HOME/repos/auto-commit/auto-commit.sh"
