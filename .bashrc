export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib64:$LD_LIBRARY_PATH" # needed for OBS
export EDITOR="/usr/local/bin/nvim"

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

alias ZZZ="xset dpms force off" # turns off monitors
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
    # Get list of all tmux sessions
    sessions=$(tmux ls 2>/dev/null)

    # TODO: add key binding to rename existing session

    # display list of sessions with fzf
    # get existing tmux session name, fall back to user query input
    # ctrl-x to delete existing session
    session=$(echo "$sessions" | cut -d: -f1 | \
        fzf --prompt="tmux: " --height=40% --reverse --border \
            --print-query \
            --bind 'ctrl-x:execute-silent(tmux kill-session -t {} && echo Killed: {})+reload(tmux ls 2>/dev/null | cut -d: -f1)' \
        | tail -n 1)

    if [[ -z "$session" ]]; then
        return 1
    fi

    if tmux has-session -t "$session" 2>/dev/null; then
        # session already exists, attach to it...
        if [ -n "$TMUX" ]; then
            # already in tmux, so use switch-client command
            echo "tmux switch-client -t $session"
            tmux switch-client -t "$session"
        else
            # not in tmux, attach normally
            echo "tmux attach -t $session"
            tmux attach -t "$session"
        fi
    else # session does not exist, create it...
        if [ -n "$TMUX" ]; then
            # Already in tmux session. Create new session without attaching to it.
            # Once created, switch to the new session
            echo "tmux new-session -d -s $session"
            tmux new-session -d -s "$session"
            echo "tmux switch-client -t $session"
            tmux switch-client -t "$session"
        else
            # Create session and attach immediately since not in tmux 
            echo "tmux new-session -s $session"
            tmux new-session -s "$session"
        fi
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

# avoid naming conflicts with obs and obs.sh
alias sbo="$HOME/.config/dotfiles/obs/obs.sh"

generate-gif() {
    # Check if correct number of arguments provided
    if [ $# -ne 2 ]; then
        echo "Usage: generate-gif <input vidoe> <output.gif>"
        echo "Example: generate-gif demo.mp4 demo.gif"
        return 1
    fi

    local input_file="$1"
    local output_file="$2"
    local palette_file="palette_tmp.png"

    # Check if input file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file '$input_file' not found"
        return 1
    fi

    # Check if input file is a video
    if ! ffmpeg -i "$input_file" -t 1 -f null - 2>/dev/null; then
        echo "Error: '$input_file' is not a valid video file"
        return 1
    fi

    echo "Converting $input_file to $output_file..."

    # Generate palette
    echo "Step 1/2: Generating color palette..."
    if ! ffmpeg -i "$input_file" -vf "fps=12,scale=640:-1:flags=lanczos,palettegen" "$palette_file" -y 2>/dev/null; then
        echo "Error: Failed to generate palette"
        return 1
    fi

    # Create GIF with palette
    echo "Step 2/2: Creating optimized GIF..."
    if ffmpeg -i "$input_file" -i "$palette_file" -filter_complex "fps=12,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse" "$output_file" -y 2>/dev/null; then
        echo "Success! Created $output_file"
        
        # Show file size
        if command -v du >/dev/null 2>&1; then
            echo "File size: $(du -h "$output_file" | cut -f1)"
        fi
    else
        echo "Error: Failed to create GIF"
        rm -f "$palette_file"
        return 1
    fi

    # Clean up temporary palette file
    rm -f "$palette_file"
    return 0
}
