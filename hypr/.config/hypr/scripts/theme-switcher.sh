#!/bin/bash
THEME_DIR="$HOME/.config/hypr/themes"
WALL_DIR="$HOME/Pictures/wallpapers"
# 1. Get choice
CHOICE=$(ls "$THEME_DIR" | grep ".conf" | grep -v "current_theme.conf" | sed 's/\.conf//' | wofi --show dmenu -p "Select Theme")

if [ -n "$CHOICE" ]; then
    # 2. Update Bridges
    ln -sf "$THEME_DIR/$CHOICE.conf" "$THEME_DIR/current_theme.conf"
    ln -sf "$THEME_DIR/$CHOICE.css" "$HOME/.config/waybar/style.css"
    
    # 3. Refresh Systems
    hyprctl reload
    
    # Waybar Check
    if pgrep -x waybar > /dev/null; then
        killall -SIGUSR2 waybar
    else
        waybar &
    fi

  # 4. Wallpaper Logic (awww)
if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img --transition-type fade "$WALL_DIR/$CHOICE.jpg"

    # 5. Notify
    notify-send "Hyprland" "Theme swapped to $CHOICE"
fi
