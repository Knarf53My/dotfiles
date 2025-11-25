#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
SUCKLESS="$DOTFILES/suckless"

echo "==> Bootstrapping dotfiles setup..."

# -----------------------------------------------------------
# 1. Create base directories
# -----------------------------------------------------------

echo "==> Creating base directories..."
mkdir -p "$HOME/.config"
mkdir -p "$DOTFILES/aliases"
mkdir -p "$SUCKLESS/dwm"
mkdir -p "$SUCKLESS/st"
mkdir -p "$SUCKLESS/slstatus"
mkdir -p "$DOTFILES/scripts"
mkdir -p "$DOTFILES/themes"
mkdir -p "$DOTFILES/wallpapers"

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

echo "==> Linking configuration files (adjust as needed)..."

# Only link if you’ve already moved these into dotfiles
link_file "$DOTFILES/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES/.vimrc" "$HOME/.vimrc"
link_file "$DOTFILES/x11/xinitrc" "$HOME/.xinitrc"
link_file "$DOTFILES/x11/Xresources" "$HOME/.Xresources"

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

echo "==> Installing required packages (Debian)..."

sudo apt update
sudo apt install -y \
    build-essential \
    libx11-dev libxft-dev libxinerama-dev \
    libfreetype6-dev libfontconfig1-dev \
    maim xclip feh \
    ranger vim git htop bmon\
    pkg-config

sudo apt install -y x11-xserver-utils

echo "==> Installing terminfo support..."
sudo apt install -y ncurses-base ncurses-term

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
            (cd "$path" && sudo make clean install)
        else
            echo "!! $name: no Makefile found in $path, skipping"
        fi
    else
        echo "!! $name: directory $path does not exist, skipping"
    fi
}

#Ensure st.info exists for st build (minimal version!)
ST_INFO="$SUCKLESS/st/st.info"
if [ ! -f "$ST_INFO" ]; then
        echo "==> Creating minimal st.info for terminfo..."
        cat > "$ST_INFO" << "EOF"
st|simpleterm,
        am,
        bel=^G,
        clear=\E[H\E[2J,
        cub1=\b,
        cud1=\n,
        cuf1=\E[C,
        cuu1=\E[A,
EOF
fi

sudo tic -sx "$ST_INFO"

build_suckless "dwm"      "$SUCKLESS/dwm"
build_suckless "st"       "$SUCKLESS/st"
build_suckless "slstatus" "$SUCKLESS/slstatus"

echo "==> Bootstrap complete!"
echo "You may want to: source ~/.bashrc  or  log out/in."

