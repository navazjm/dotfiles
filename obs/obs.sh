#!/bin/bash

#
# Copyright (c) 2025 Michael Navarro
# MIT license, see LICENSE for more
#
# obs.sh - helper commands to install/update/uninstall obs on void-linux.
#

set -e

LOCAL_BIN_DIR="$HOME/.local/bin"
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_PATH="$SCRIPT_PATH/tmp" # where we temporarily store obs-studio and obs-cef 

OBS_STUDIO_PATH="$TMP_PATH/obs-studio"
OBS_BUILD_PATH="$OBS_STUDIO_PATH/build/vl"
OBS_CEF_PATH="$TMP_PATH/cef"
OBS_CEF_TAR_FILE="$TMP_PATH/cef.tar.xz"
OBS_CEF_TAR_URL="https://cdn-fastly.obsproject.com/downloads/cef_binary_6533_linux_x86_64.tar.xz"

# Download function with fallback
download_obs_cef() {
    if command -v wget >/dev/null 2>&1; then
        wget "$OBS_CEF_TAR_URL" -O "$OBS_CEF_TAR_FILE" || return 1
    elif command -v curl >/dev/null 2>&1; then
        curl -L "$OBS_CEF_TAR_URL" -o "$OBS_CEF_TAR_FILE" || return 1
    else
        echo "Error: Neither wget nor curl found"
        return 1
    fi
}

# Commands to install/update obs
install() {
    rm -rf "$TMP_PATH"
    APPLY_WEBRTC_PATCH=0

    # Check for optional second argument
    case "$2" in
        "") ;; # No flag provided – default behavior
        --disable-webrtc) APPLY_WEBRTC_PATCH=1 ;;
        *) echo "Unknown option: $2"; help; exit 1 ;;
    esac

    ## Download and untar pre-built obs-browser CEF framework 

    echo "[INFO] mkdir $OBS_CEF_PATH" 
    mkdir -p "$OBS_CEF_PATH"  

    echo "[INFO] fetching $OBS_CEF_TAR_URL" 
    download_obs_cef || exit 1

    echo "[INFO] tar $OBS_CEF_TAR_FILE" 
    tar --strip-components=1 -xf "$OBS_CEF_TAR_FILE" -C "$OBS_CEF_PATH"

    echo "[INFO] rm $OBS_CEF_TAR_FILE" 
    rm "$OBS_CEF_TAR_FILE"

    # clone obs source code and submodules

    echo "[INFO] mkdir $OBS_STUDIO_PATH" 
    mkdir -p "$OBS_STUDIO_PATH"  

    git clone --recurse-submodules --depth=1 --shallow-submodules https://github.com/obsproject/obs-studio.git "$OBS_STUDIO_PATH"

    # symlink our custom cmake preset 

    ln -sf "$SCRIPT_PATH/CMakeUserPresets.json" "$OBS_STUDIO_PATH/CMakeUserPresets.json" \
        && echo "[INFO] CMakeUserPresets.json: Symlink created successfully." \
        || echo "[INFO] CMakeUserPresets.json: Failed to create symlink."

    # Build and Install obs

    cd "$OBS_STUDIO_PATH"

    if [ "$APPLY_WEBRTC_PATCH" -eq 1 ]; then
        echo "[INFO] Applying obs-webrtc patch (disabling WebRTC plugin)"
        git apply "$SCRIPT_PATH/obs-webrtc.patch"
    else
        echo "[INFO] Building OBS with WebRTC plugin enabled"
    fi

    cmake --preset vl
    cmake --build $OBS_BUILD_PATH
    cmake --install $OBS_BUILD_PATH --prefix $HOME/.local

    rm -rf "$TMP_PATH"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ 🎉 OBS INSTALLED SUCCESSFULLY! 🎉 ✨"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Commands to remove obs from user's system.
# Only removes the files generated from this script. 
# Does NOT remove any files created by obs itself.
uninstall() {
    rm -rf "$HOME/.local/lib64" # where obs installs .so files
    rm "$HOME/.local/bin/obs"
    rm "$HOME/.local/bin/obs-ffmpeg-mux"
}

# Add $HOME/.local/bin to PATH => obs installation location 
# Add $HOME/.local/lib64 to LD_LIBRARY_PATH => obs built .so files location
setup() {
    case "$(basename "$SHELL")" in
        bash) 
            CONFIG_FILE="$HOME/.bashrc"
            echo "[INFO] Add $LOCAL_BIN_DIR to PATH" 
            if ! grep -q 'export PATH=.*\.local/bin' "$CONFIG_FILE" 2>/dev/null; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$CONFIG_FILE"
            fi
            echo "[INFO] Add $HOME/.local/lib64 to LD_LIBRARY_PATH" 
            if ! grep -q 'LD_LIBRARY_PATH.*.local/lib64' "$CONFIG_FILE" 2>/dev/null; then
                echo 'export LD_LIBRARY_PATH="$HOME/.local/lib64:$LD_LIBRARY_PATH" # needed for OBS' >> "$CONFIG_FILE"
            fi
            ;;
        zsh) 
            CONFIG_FILE="$HOME/.zshrc"
            echo "[INFO] Add $LOCAL_BIN_DIR to PATH" 
            if ! grep -q 'export PATH=.*\.local/bin' "$CONFIG_FILE" 2>/dev/null; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$CONFIG_FILE"
            fi
            echo "[INFO] Add $HOME/.local/lib64 to LD_LIBRARY_PATH" 
            if ! grep -q 'LD_LIBRARY_PATH.*.local/lib64' "$CONFIG_FILE" 2>/dev/null; then
                echo 'export LD_LIBRARY_PATH="$HOME/.local/lib64:$LD_LIBRARY_PATH" # needed for OBS' >> "$CONFIG_FILE"
            fi
            ;;
        fish) 
            CONFIG_FILE="$HOME/.config/fish/config.fish"
            mkdir -p "$(dirname "$CONFIG_FILE")"
            echo "[INFO] Add $LOCAL_BIN_DIR to PATH" 
            if ! grep -q 'set -x PATH.*\.local/bin' "$CONFIG_FILE" 2>/dev/null; then
                echo 'set -x PATH $HOME/.local/bin $PATH' >> "$CONFIG_FILE"
            fi
            echo "[INFO] Add $HOME/.local/lib64 to LD_LIBRARY_PATH" 
            if ! grep -q "$HOME/.local/lib64" "$CONFIG_FILE" 2>/dev/null; then
                echo 'set -x LD_LIBRARY_PATH $HOME/.local/lib64 $LD_LIBRARY_PATH' >> "$CONFIG_FILE"
            fi
            ;;
        *) 
            CONFIG_FILE="$HOME/.profile"
            if ! grep -q "$LOCAL_BIN_DIR" "$CONFIG_FILE" 2>/dev/null; then
                echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$CONFIG_FILE"
            fi
            if ! grep -q 'LD_LIBRARY_PATH.*.local/lib64' "$CONFIG_FILE" 2>/dev/null; then
                echo 'export LD_LIBRARY_PATH="$HOME/.local/lib64:$LD_LIBRARY_PATH" # needed for OBS' >> "$CONFIG_FILE"
            fi
            ;;
    esac
}

# Show help
help() {
    echo "Usage: $0 [install|setup|uninstall|help]"
    echo "  install     Installs/updates OBS Studio from source"
    echo "  setup       Adds required paths to your shell config"
    echo "  uninstall   Removes OBS binaries and libraries installed by script"
    echo "  help        Displays usage instructions"
}

# Main
case "$1" in
    install|update) install "$@" ;;
    setup) setup ;;
    uninstall) uninstall ;;
    help|-h|--help|usage|"") help ;;
    *) echo "Unknown option: $1"; help; exit 1 ;;
esac
