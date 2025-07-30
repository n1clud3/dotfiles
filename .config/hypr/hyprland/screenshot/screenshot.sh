#!/bin/bash

# Sound settings
sound_path="$HOME/.config/hypr/hyprland/screenshot/camera_shutter.mp3"

# Notification settings
notify_app_name="$(basename $0)"
notify_summary="Screenshot taken"
notify_desc="Copied to clipboard and stored to $(xdg-user-dir PICTURES)/Screenshots"

filepath="$(xdg-user-dir PICTURES)/Screenshots/screenshot-$(date +%F-%H-%M-%S).png"

mkdir -p "$(xdg-user-dir PICTURES)/Screenshots"

if [[ $1 == "area" ]] then
    echo "Capturing area ..."
    grim "/tmp/screenshot_selection.png"
    imv -f -s full "/tmp/screenshot_selection.png" &
    imv_pid=$!
    sleep 0.1
    selection="$(slurp -d -c FBF200ff -b 1A4B4177 -F 'JetBrainsMono NL')"
    sleep 0.14
    grim -g "$selection" $filepath
    kill $imv_pid
    rm "/tmp/screenshot_selection.png"
else
    echo "Capturing entire screen ..."
    grim $filepath
fi

wl-copy < $filepath

echo "Screenshot created! Stored to $filepath"
notify-send --urgency=low --app-name=$notify_app_name "$notify_summary" "$notify_desc" & pw-play $sound_path
