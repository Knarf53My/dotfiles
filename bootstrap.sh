#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
SUCKLESS="$DOTFILES/suckless"
UPDATE_MODE=0
XDG_SESSION_DIR="/usr/share/xsessions"
DWM_SESSION_SCRIPT="$DOTFILES/configs/.config/dwm/dwm-sessions.sh"

echo "==> Bootstrapping dotfiles setup..."

# -----------------------------------------------------------
# 0. Check for update flag
# -----------------------------------------------------------
if [[ "$1" == "--update" ]]; then
    echo "==> Running in UPDATE mode (skipping package installation)..."
    UPDATE_MODE=1
fi

# -----------------------------------------------------------
# 1. Create base directories
# -----------------------------------------------------------

echo "==> Creating base directories..."
mkdir -p "$HOME/.config"
mkdir -p "$DOTFILES/aliases"
mkdir -p "$SUCKLESS/dwm"
mkdir -p "$SUCKLESS/slstatus"
mkdir -p "$DOTFILES/scripts"
mkdir -p "$DOTFILES/themes"
mkdir -p "$DOTFILES/wallpapers"
mkdir -p "$DOTFILES/screenshots"
mkdir -p "$DOTFILES/configs/.config/xsessions"


# -----------------------------------------------------------
# 3. Install essential packages (Debian-based)
# -----------------------------------------------------------\

if [ "$UPDATE_MODE" -eq 0 ]; then
    echo "==> Installing required packages (Debian)..."

    sudo apt update
    
    # CRITICAL: Build essentials and all X libs (Fixes DWM crashing)
    # Packages consolidated for robust installation.
    sudo apt install -y build-essential libx11-dev libxft-dev libxinerama-dev libfreetype6-dev libfontconfig1-dev pkg-config maim xclip feh alacritty firefox-esr lightdm lightdm-gtk-greeter xorg xinit x11-xserver-utils ncurses-base ncurses-term

else
    echo "==> Skipping package installation in update mode."
fi

# -----------------------------------------------------------
# 4. Initial suckless build (if sources exist)
# -----------------------------------------------------------

echo "==> Building suckless tools (if sources exist)..."

build_suckless() {
    local name="$1"
    local path="$2"

    if [ -d "$path" ]; then
        if [ -f "$path/Makefile" ]; then
            echo "--> Building $name in $path"
            (cd "$path" && sudo make clean install)
        else
            echo "!! $name: directory exists ($path), but no Makefile found. Did you clone the source code into this directory?"
        fi
    else
        echo "!! $name: source directory $path does not exist, skipping build."
    fi
}
build_suckless "dwm"      "$SUCKLESS/dwm"
build_suckless "slstatus" "$SUCKLESS/slstatus"

# -----------------------------------------------------------
# 5. Configuration Symlinks
# -----------------------------------------------------------
echo "==> Creating essential configuration symlinks..."

# Helper: safe symlink function
safe_symlink() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && ! [ -L "$dest" ]; then
        echo "--> Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    if [ -e "$src" ]; then
        ln -sf "$src" "$dest"
        echo "--> Linked $src to $dest"
    else
        echo "!! WARNING: Source file/directory not found: $src"
    fi
}

# --- A. Link Core Hidden Files ---
safe_symlink "$DOTFILES/configs/.bashrc" "$HOME/.bashrc"
safe_symlink "$DOTFILES/configs/.vimrc" "$HOME/.vimrc"
safe_symlink "$DOTFILES/configs/.xinitrc" "$HOME/.xinitrc"

# --- B. Link .config Directory ---
# This links the entire internal .config folder to $HOME/.config
# Note: This assumes you handle conflicts within $DOTFILES/configs/.config
safe_symlink "$DOTFILES/configs/.config/" "$HOME/.config/"

# -----------------------------------------------------------
# 6. Enable and Start LightDM Service (Guarantee)
# -----------------------------------------------------------
echo "==> Enabling and starting LightDM service..."
sudo systemctl enable lightdm
# We keep the start command here if it was run outside of X

# -----------------------------------------------------------
# 7. LightDM/Xsession Deployment (MUST run every time)
# -----------------------------------------------------------
echo "==> Deploying DWM session files and executable permissions..."

# A. Create the necessary directory before copying
sudo mkdir -p "/usr/share/xsessions"

# B. CRITICAL: Grant executable permission to the session script
if [ -f "$DWM_SESSION_SCRIPT" ]; then
    chmod a+x "$DWM_SESSION_SCRIPT"
    echo "Set executable permission on dwm-sessions.sh"
else
    echo "!! ERROR: DWM session script not found at $DWM_SESSION_SCRIPT"
    exit 1
fi

# C. CRITICAL: Deploy the .desktop file to the system
DWM_DESKTOP_SRC="$DOTFILES/configs/.config/xsessions/dwm.desktop"
if [ -f "$DWM_DESKTOP_SRC" ]; then
    sudo cp "$DWM_DESKTOP_SRC" "$XDG_SESSION_DIR/dwm.desktop"
    echo "-> DWM session file copied to $XDG_SESSION_DIR/dwm.desktop"
else
    echo "!! ERROR: dwm.desktop source file not found. Cannot deploy session."
    exit 1
fi

# D. Start LightDM service immediately after deployment (guarantee)
sudo systemctl start lightdm

echo "==> Bootstrap complete! Rebooting is recommended."
