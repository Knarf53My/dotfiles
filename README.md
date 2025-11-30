# Debian 13 Trixie with DWM window manager.

Dotfiles to set up a full working DWM window manager environment.

Clean, minimal, fast — with dwm, slstatus, themes, scripts, aliases,
and a complete bootstrap system.

# Installation (simple + recommended)

Clone this repository into ~/.dotfiles:

    git clone https://github.com/Knarf53My/dotfiles.git ~/.dotfiles

Enter the folder:

    cd ~/.dotfiles

Run the bootstrap script:

    ./bootstrap.sh

This script will:

-   install required packages
-   build dwm and slstatus
-   create the needed symlinks
-   install themes, aliases, scripts, and wallpapers
-   install login manager
-   configure fonts and terminal
-   prepare your environment for use

When finished, restart X:

    pkill X
    startx

(Or simply log out and back in.)

# Updating

To sync updates from the repository:

    cd ~/.dotfiles
    git pull
    ./bootstrap.sh --update

This will rebuild the suckless programs and refresh symlinks.

# Components

-   dwm (window manager)
-   Alacritty (terminal emulator)
-   slstatus (status bar)
-   vim setup
-   aliases for system and dev usage
-   themes (Gruvbox, Nord, Nord Dark)
-   rebuild scripts for fast recompiling

# Philosophy

This setup follows the classic suckless workflow:

-   edit → build → use
-   no heavy frameworks
-   configuration in headers
-   rebuild scripts for development
-   everything portable in .dotfiles

# Scripts used:

In /dotfiles/scripts:

    - freeze.sh                --- Saves a list of installed packages and configuration files
    - install_custom_bashrc.sh --- Creates a colorful, Git-aware PS1 prompt configuration.
    - install_fzf.sh           --- Installs the Fuzzy Finder utility and configures Bash history search.
    - rebuild.sh               --- Script to recompile all Suckless tools (dwm, slstatus) at once.

In /dotfiles:

    - bootstrap.sh             --- Installs system dependencies, builds suckless, and deploys configuration.

In /dotfiles/configs/.config/dwm:

    - autostart.sh             --- Starts background processes (slstatus, feh) when the DWM session begins.
    - dwm-sessions.sh          --- The main session file executed by LightDM.


