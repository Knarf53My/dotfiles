# autostart applications
feh --bg-fill ~/dotfiles/wallpapers/debian.png &
~/.config/dwm/autostart.sh &
slstatus &
# tag 1 terminal (rule sends it to tag 1)
# terminal st, firefox-esr 
# tag 2 firefox (rule sends it to tag 2)
st &
# tag 3: three terminals
st -n t3a &
sleep 0.8
st -n t3b &
sleep 0.8
st -n t3c &
# tag 4
# Choice of application 

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

