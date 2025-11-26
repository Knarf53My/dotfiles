#!/bin/bash

# 1. Initialize X Resources (colors, fonts, X-based settings)
xrdb -merge $HOME/.Xresources

# 2. Start all background services (MUST use '&')
# These processes run alongside DWM and keep the session active.

# DWM Autostart Script: For other background apps
# This usually runs things like nm-applet, polkit, compositor, etc.
"$HOME/.config/dwm/autostart.sh" &

# Wallpaper (FEH): Using --bg-scale and robust path ($HOME)
feh --bg-scale --no-xinerama "$HOME/dotfiles/wallpapers/debian.png" &

# Status Bar: slstatus
slstatus &

# Optional: Autoconnect Bluetooth speaker
# (
#     sleep 2
#     bluetoothctl power on
#     bluetoothctl connect 99:D5:BC:1A:C0:95
# ) &

# 3. AUTO-STARTED TERMINALS (MUST use '&')

# Tag 1 terminal
alacritty --class Alacritty,t1 &

# Tag 3 — three terminals (Use sleep to help DWM place them correctly)
alacritty --class Alacritty,t3a &
sleep 0.8
alacritty --class Alacritty,t3b &
sleep 0.8
alacritty --class Alacritty,t3c &

# 4. EXECUTE WINDOW MANAGER (MUST be the final line and NOT use '&')
# The X session will end when DWM exits.
exec dwm
