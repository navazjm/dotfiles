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

#Azile shell prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(azile init zsh)"
fi

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## Aliases

alias lg="lazygit"

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
alias gch="git checkout"
alias grst="git restore"

alias cl="clear"
alias ..="cd .."

alias cfg="cd $HOME/.config"
export DOTFILES="$HOME/.config/dotfiles"
alias cdot="cd $DOTFILES"
alias vi="nvim"
alias vd="vi $DOTFILES"
alias vn="vi $DOTFILES/nvim/init.lua"
alias vt="vi $DOTFILES/.tmux.conf"
alias vz="vi $DOTFILES/.zshrc"

alias ac="$HOME/repos/auto-commit/auto-commit.sh"

# Search for a running process and kill it
alias proc="ps aux | fzf | awk '{print $2}' | xargs kill"

# Use fzf to choose a session or create a new one
tm() {
    if [ -n "$TMUX" ]; then
      echo "ERROR: Already inside a tmux session."
      return 1
    fi

    # List all tmux sessions
    sessions=$(tmux ls 2>/dev/null)

    # TODO: add key binding to rename existing session

    # get existing tmux session name, fall back to user query input
    session=$(echo "$sessions" | cut -d: -f1 | \
        fzf --prompt="tmux: " --height=40% --reverse --border \
            --print-query \
            --bind 'ctrl-x:execute-silent(tmux kill-session -t {} && echo Killed: {})+reload(tmux ls 2>/dev/null | cut -d: -f1)' \
        | tail -n 1)

    if [[ -z "$session" ]]; then
        return
    fi

    if tmux has-session -t "$session" 2>/dev/null; then
        # Attach to the selected session
        echo tmux a -t "$session"
        tmux a -t "$session"
    else
        # Create a new session with the typed name
        echo tmux new-session -s "$session"
        tmux new-session -s "$session"
    fi
}

# crun
# ----
# Recursively searches upward from the current directory to locate the root
# of a C project by finding a `scripts/run.sh` file. Once located, it executes
# `scripts/run.sh` from the project root, forwarding any command-line arguments.
#
# This function is useful for running a consistent entry script from anywhere
# within your C project's directory tree.
#
# Usage:
#   crun                     # runs scripts/run.sh
#   crun --arg1 --arg2 ...   # passes arguments to scripts/run.sh
crun() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/scripts/run.sh" ]]; then
            (cd "$dir" && ./scripts/run.sh "$@")
            return
        fi
        dir=$(dirname "$dir")
    done
    echo "Could not find scripts/run.sh"
}
