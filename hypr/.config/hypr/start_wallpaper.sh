#!/bin/bash
THEME_DIR="$HOME/.config/hypr/themes"
WALL_DIR="$HOME/Pictures/wallpapers"

# Bootstrap current symlink and app styles if missing (e.g. fresh stow)
if [ ! -L "$THEME_DIR/current" ]; then
    ln -sfn "$THEME_DIR/glass" "$THEME_DIR/current"
fi
ln -sf "$THEME_DIR/current/waybar.css" "$HOME/.config/waybar/style.css"
ln -sf "$THEME_DIR/current/wofi.css"   "$HOME/.config/wofi/style.css"

pkill awww-daemon || true
awww-daemon &
sleep 1

if [ -f "$THEME_DIR/current/wallpaper" ]; then
    WALL="$WALL_DIR/$(cat "$THEME_DIR/current/wallpaper" | tr -d '[:space:]')"
else
    WALL="$WALL_DIR/glass.jpg"
fi

awww img --transition-type fade "$WALL"
