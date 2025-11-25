# autostart applications
feh --bg-fill ~/dotfiles/wallpapers/debian.png &

~/.config/dwm/autostart.sh &

slstatus &

### --- AUTO-STARTED TERMINALS --- ###

# Tag 1 terminal
alacritty --class Alacritty,t1 &

# Tag 3 — three terminals
alacritty --class Alacritty,t3a &
sleep 0.8
alacritty --class Alacritty,t3b &
sleep 0.8
alacritty --class Alacritty,t3c &

# Autoconnect Bluetooth speaker, change if you 
# want Bluetooth automatically connected!
# (
#    sleep 2
#    bluetoothctl power on
#    bluetoothctl connect 99:D5:BC:1A:C0:95
# ) &

# Loading DWM
while true; do
    dwm || break
done

