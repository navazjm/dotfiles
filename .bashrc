export PATH=$HOME/.local/bin:$PATH

#Azile shell prompt
eval "$(azile init bash)"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#fzf
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash

## Aliases

alias LOGOUT="pkill awesome"
alias REBOOT="sudo reboot"
alias POWEROFF="sudo poweroff"

alias sb="source ~/.bashrc"
alias lg="lazygit"
alias sp="spotify_player"

#replace ls with eza
alias ls="eza -lahF --icons --classify"
alias lsr="ls -RT"
alias la="ls --grid"
export EZA_COLORS="di=35"

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

export DOTFILES="$HOME/.config/dotfiles"
alias cdot="cd $DOTFILES"
alias vi="nvim"
alias vb="vi $DOTFILES/.bashrc"
alias vd="vi $DOTFILES"
alias vn="vi $DOTFILES/nvim/init.lua"
alias vt="vi $DOTFILES/.tmux.conf"

alias ac="$HOME/dev/auto-commit/auto-commit.sh"

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

if [ -f "$HOME/.bash_env" ]; then
    source "$HOME/.bash_env"
fi

connect_bluetooth() {
    local MAC="$1"
    echo "Connecting via bluetooth ($MAC)..."
    bluetoothctl << EOF
power on
connect $MAC
EOF
}

alias cbh="connect_bluetooth F8:4E:17:9C:F1:65"
alias cbs="connect_bluetooth FC:A8:9A:6A:8F:23"

