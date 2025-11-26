#!/bin/bash

# This script is executed directly by LightDM to ensure a clean session start.

# 1. Initialize X Resources (colors, fonts, X-based settings)
xrdb -merge "$HOME/.Xresources" &

# 2. Execute xrandr/autostart logic. (Use a timeout in case it hangs)
"$HOME/.config/dwm/autostart.sh" &
sleep 1.0

# 3. Start all background services (MUST use '&')
feh --bg-scale --scale-down --no-xinerama "$HOME/dotfiles/wallpapers/73.png" &

# Status Bar: slstatus
"$HOME/dotfiles/suckless/slstatus/slstatus" &

# 4. EXECUTE WINDOW MANAGER
# CRITICAL: This MUST be the last command, and it MUST use 'exec'.
exec dwm
