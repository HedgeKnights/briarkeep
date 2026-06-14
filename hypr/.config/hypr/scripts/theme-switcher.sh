#!/bin/bash
THEME_DIR="$HOME/.config/hypr/themes"
WALL_DIR="$HOME/Pictures/wallpapers"

CHOICE=$(find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d \
  | xargs -I{} basename {} \
  | wofi --show dmenu -p "Select Theme")

[ -z "$CHOICE" ] && exit 0

# Switch active theme (relative symlink so Hyprland's glob can resolve it)
ln -sfn "$CHOICE" "$THEME_DIR/current"

# Apply per-app styles
ln -sf "$THEME_DIR/current/waybar.css" "$HOME/.config/waybar/style.css"
ln -sf "$THEME_DIR/current/wofi.css"   "$HOME/.config/wofi/style.css"

# Reload Hyprland (sources current/hypr.conf)
hyprctl reload

# Reload waybar styles live
if pgrep -x waybar > /dev/null; then
    killall -SIGUSR2 waybar
else
    waybar &
fi

# Set wallpaper
WALL_FILE="$THEME_DIR/current/wallpaper"
if [ -f "$WALL_FILE" ]; then
    WALL="$WALL_DIR/$(cat "$WALL_FILE" | tr -d '[:space:]')"
else
    WALL="$WALL_DIR/$CHOICE.jpg"
fi

if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 0.5
fi
awww img --transition-type fade "$WALL"

# Reload Ghostty theme
GHOSTTY_THEME=$(cat "$THEME_DIR/current/ghostty-theme" 2>/dev/null | tr -d '\n')
if [ -n "$GHOSTTY_THEME" ]; then
    mkdir -p "$HOME/.cache/ghostty"
    echo "theme = $GHOSTTY_THEME" > "$HOME/.cache/ghostty/theme.conf"
    pkill -SIGUSR2 ghostty 2>/dev/null || true
fi

# Reload running nvim instances
NVIM_THEME=$(cat "$THEME_DIR/current/nvim-theme" 2>/dev/null | tr -d '[:space:]')
if [ -n "$NVIM_THEME" ]; then
  for sock in $(find /tmp -maxdepth 3 -name 'nvim.*.0' -type s 2>/dev/null); do
    nvim --server "$sock" --remote-send ":lua require('theme').reload()<CR>" 2>/dev/null || true
  done
fi

notify-send "Hyprland" "Theme: $CHOICE"
