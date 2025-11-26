#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
SUCKLESS="$DOTFILES/suckless"
UPDATE_MODE=0

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
mkdir -p "$DOTFILES/screenshots" # Ensure screenshots dir exists for maim
mkdir -p "$DOTFILES/configs/.config/xsessions" # NEW: Directory for the DWM session file

# -----------------------------------------------------------
# 2. Helper: safe symlink
# -----------------------------------------------------------

link_file() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "!! Source $src does not exist, skipping"
        return
    fi

    if [ -L "$dest" ]; then
        echo "-> Replacing existing symlink $dest"
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        echo "!! $dest already exists and is not a symlink, skipping"
        return
    fi

    echo "-> Linking $src → $dest"
    ln -s "$src" "$dest"
}

echo "==> Linking configuration files..."

# Bash config
link_file "$DOTFILES/configs/.bashrc" "$HOME/.bashrc"

# Vim config
link_file "$DOTFILES/configs/.vimrc" "$HOME/.vimrc"

# X init (used by startx)
link_file "$DOTFILES/configs/.xinitrc" "$HOME/.xinitrc"

# Xresources
link_file "$DOTFILES/configs/.Xresources" "$HOME/.Xresources"

# dwm autostart script
mkdir -p "$HOME/.config/dwm"
link_file "$DOTFILES/configs/.config/dwm/autostart.sh" "$HOME/.config/dwm/autostart.sh"

# -----------------------------------------------------------
# 3. Ensure aliases auto-load
# -----------------------------------------------------------

echo "==> Ensuring .bashrc loads modular aliases..."

ALIASES_BLOCK_MARKER="# Load modular aliases from ~/dotfiles (AUTO-INSERTED)"
ALIASES_BLOCK='
# Load modular aliases from ~/dotfiles (AUTO-INSERTED)
if [ -d "$HOME/dotfiles/aliases" ]; then
  for f in "$HOME/dotfiles/aliases/"*.sh; do
    [ -f "$f" ] && . "$f"
  done
fi
'

if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "$ALIASES_BLOCK_MARKER" "$HOME/.bashrc"; then
        printf "\n%s\n" "$ALIASES_BLOCK" >> "$HOME/.bashrc"
        echo "-> Added alias loader to ~/.bashrc"
    else
        echo "-> Alias loader already present in ~/.bashrc"
    fi
else
    echo "!! No ~/.bashrc found, you may want to link or create one."
fi

# -----------------------------------------------------------
# 4. Install essential packages (Debian-based)
# -----------------------------------------------------------

if [ "$UPDATE_MODE" -eq 0 ]; then
    echo "==> Installing required packages (Debian)..."

    sudo apt update
    
    # 4a. Build essentials and X libs
    sudo apt install -y build-essential libx11-dev libxft-dev libxinerama-dev libfreetype6-dev libfontconfig1-dev pkg-config
    
    # 4b. Utilities and applications (Firefox-esr, Rofi, and LightDM included)
    sudo apt install -y maim xclip feh alacritty firefox-esr rofi lightdm lightdm-gtk-greeter
    
    # 4c. X system and terminfo
    sudo apt install -y xorg xinit x11-xserver-utils ncurses-base ncurses-term

else
    echo "==> Skipping package installation in update mode."
fi

# -----------------------------------------------------------
# 5. Initial suckless build (if sources exist)
# -----------------------------------------------------------

echo "==> Building suckless tools (if sources exist)..."

build_suckless() {
    local name="$1"
    local path="$2"

    if [ -d "$path" ]; then
        if [ -f "$path/Makefile" ]; then
            echo "--> Building $name in $path"
            # Use 'make clean install' for full rebuild/install cycle
            (cd "$path" && sudo make clean install)
        else
            echo "!! $name: directory exists ($path), but no Makefile found. Did you clone the source code into this directory?"
        fi
    }
}
build_suckless "dwm"      "$SUCKLESS/dwm"
build_suckless "slstatus" "$SUCKLESS/slstatus"


# -----------------------------------------------------------
# 6. LightDM/Xsession Setup
# -----------------------------------------------------------
echo "==> Configuring LightDM session for DWM..."

if [ "$UPDATE_MODE" -eq 0 ]; then
    # Create the necessary directory before copying
    sudo mkdir -p "/usr/share/xsessions"
    
    # Copy the DWM session file to the system directory (requires sudo)
    sudo cp "$DOTFILES/configs/.config/xsessions/dwm.desktop" "/usr/share/xsessions/dwm.desktop"
    echo "-> DWM session file copied to /usr/share/xsessions/dwm.desktop"
fi

echo "==> Bootstrap complete!"
echo "You may want to: source ~/.bashrc  or  log out/in."
