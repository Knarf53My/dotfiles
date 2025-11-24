🌙 dwm-setup

Dotfiles to set up a full working DWM window manager environment.

Clean, minimal, fast — with dwm, st, slstatus, themes, scripts, aliases,
and a complete bootstrap system.

📦 Installation (simple + recommended)

Clone this repository into ~/.dotfiles:

    git clone https://github.com/Knarf53My/dwm-setup.git ~/.dotfiles

Enter the folder:

    cd ~/.dotfiles

Run the bootstrap script:

    ./bootstrap.sh

This script will:

-   install required packages
-   build dwm, st, slstatus
-   create the needed symlinks
-   install themes, aliases, scripts, and wallpapers
-   configure fonts and terminal
-   prepare your environment for use

When finished, restart X:

    pkill X
    startx

(Or simply log out and back in.)

🔄 Updating

To sync updates from the repository:

    cd ~/.dotfiles
    git pull
    ./bootstrap.sh --update

This will rebuild the suckless programs and refresh symlinks.

🧩 Components

-   dwm (window manager)
-   st (terminal emulator)
-   slstatus (status bar)
-   vim setup
-   aliases for system and dev usage
-   themes (Gruvbox, Nord, Nord Dark)
-   rebuild scripts for fast recompiling

🏗 Philosophy

This setup follows the classic suckless workflow:

-   edit → build → use
-   no heavy frameworks
-   configuration in headers
-   rebuild scripts for development
-   everything portable in .dotfiles

