#!/bin/bash
THEME_DIR="$HOME/.config/hypr/themes"
WALL_DIR="$HOME/Images/wallpapers"

CHOICE=$(find -L "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d ! -name 'current' -printf '%f\n' \
  | sort \
  | wofi --show dmenu -p "Select Theme" --lines 10)

[ -z "$CHOICE" ] && exit 0

# Validate choice is an actual theme directory
if [ ! -d "$THEME_DIR/$CHOICE" ]; then
    notify-send "Theme Switcher" "Unknown theme: $CHOICE" --urgency=critical
    exit 1
fi

# Switch active theme (relative symlink so Hyprland's glob can resolve it)
ln -sfn "$CHOICE" "$THEME_DIR/current"

# Apply per-app styles
ln -sf "$THEME_DIR/current/waybar.css" "$HOME/.config/waybar/style.css"
ln -sf "$THEME_DIR/current/wofi.css"   "$HOME/.config/wofi/style.css"

# Reload Hyprland (sources current/hypr.conf)
hyprctl reload

# Reload waybar with new CSS (kill+restart is more reliable than signals in 0.15)
pkill -x waybar 2>/dev/null || true
sleep 0.2
waybar &>/dev/null &

# Set wallpaper
WALL_FILE="$THEME_DIR/current/wallpaper"
if [ -f "$WALL_FILE" ]; then
    WALL="$WALL_DIR/$(cat "$WALL_FILE" | tr -d '[:space:]')"
else
    WALL="$WALL_DIR/$CHOICE.jpg"
fi

if [ -f "$WALL" ]; then
    if ! pgrep -x awww-daemon > /dev/null; then
        awww-daemon &
        sleep 0.5
    fi
    awww img --transition-type fade "$WALL"
fi

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

# btop - update config and signal reload
BTOP_THEME=$(cat "$THEME_DIR/current/btop-theme" 2>/dev/null | tr -d '[:space:]')
if [ -n "$BTOP_THEME" ]; then
    BTOP_CONF="$HOME/.config/btop/btop.conf"
    if [ -f "$BTOP_CONF" ]; then
        sed -i "s/^color_theme = .*/color_theme = \"$BTOP_THEME\"/" "$BTOP_CONF"
        pkill -SIGUSR1 btop 2>/dev/null || true
    fi
fi

# htop - update color scheme (takes effect on next launch)
HTOP_SCHEME=$(cat "$THEME_DIR/current/htop-colorscheme" 2>/dev/null | tr -d '[:space:]')
if [ -n "$HTOP_SCHEME" ]; then
    HTOP_RC="$HOME/.config/htop/htoprc"
    if [ -f "$HTOP_RC" ]; then
        sed -i "s/^color_scheme=.*/color_scheme=$HTOP_SCHEME/" "$HTOP_RC"
    fi
fi

# GTK - update settings.ini and signal running apps
GTK_THEME=$(cat "$THEME_DIR/current/gtk-theme" 2>/dev/null | tr -d '[:space:]')
if [ -n "$GTK_THEME" ]; then
    GTK_CONF="$HOME/.config/gtk-3.0/settings.ini"
    if [ -f "$GTK_CONF" ]; then
        sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" "$GTK_CONF"
    fi
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
fi

# Obsidian - copy CSS snippet (Obsidian hot-reloads snippet files automatically)
OBSIDIAN_CSS="$THEME_DIR/current/obsidian.css"
OBSIDIAN_SNIPPETS="$HOME/Obsidian_Tower/.obsidian/snippets"
if [ -f "$OBSIDIAN_CSS" ] && [ -d "$OBSIDIAN_SNIPPETS" ]; then
    cp "$OBSIDIAN_CSS" "$OBSIDIAN_SNIPPETS/active-theme.css"
fi

# Dunst - symlink per-theme colors and live-reload
DUNST_COLORS="$THEME_DIR/current/dunst-colors.conf"
DUNST_CONF_DIR="$HOME/.config/dunst"
if [ -f "$DUNST_COLORS" ] && [ -d "$DUNST_CONF_DIR" ]; then
    ln -sf "$DUNST_COLORS" "$DUNST_CONF_DIR/dunst-colors.conf"
    dunstctl reload "$DUNST_CONF_DIR/dunstrc" "$DUNST_CONF_DIR/dunst-colors.conf" 2>/dev/null || true
fi

# Discord via Vencord quickCss — requires Vesktop restart to take effect
DISCORD_CSS="$THEME_DIR/current/discord.css"
VESKTOP_QUICKCSS="$HOME/.config/vesktop/settings/quickCss.css"
if [ -f "$DISCORD_CSS" ] && [ -d "$(dirname "$VESKTOP_QUICKCSS")" ]; then
    cp "$DISCORD_CSS" "$VESKTOP_QUICKCSS"
    if pgrep -x vesktop > /dev/null; then
        pkill -x vesktop
        sleep 0.5
        vesktop &>/dev/null &
    fi
fi

# Spotify via Spicetify — update config always; apply only if Spotify is already running
SPOTIFY_THEME_RAW=$(cat "$THEME_DIR/current/spotify-theme" 2>/dev/null | tr -d '[:space:]')
if [ -n "$SPOTIFY_THEME_RAW" ] && command -v spicetify &>/dev/null; then
    if [[ "$SPOTIFY_THEME_RAW" == *:* ]]; then
        SPICETIFY_THEME="${SPOTIFY_THEME_RAW%%:*}"
        SPICETIFY_SCHEME="${SPOTIFY_THEME_RAW#*:}"
        spicetify config current_theme "$SPICETIFY_THEME" color_scheme "$SPICETIFY_SCHEME" 2>/dev/null
    else
        spicetify config current_theme "$SPOTIFY_THEME_RAW" 2>/dev/null
    fi
    spicetify apply 2>/dev/null || true
fi

# Hyprlock - symlink per-theme config
HYPRLOCK_CONF="$THEME_DIR/current/hyprlock.conf"
if [ -f "$HYPRLOCK_CONF" ]; then
    ln -sf "$HYPRLOCK_CONF" "$HOME/.config/hypr/hyprlock.conf"
fi

# Starship prompt - symlink per-theme config (takes effect on next shell prompt)
STARSHIP_CONF="$THEME_DIR/current/starship.toml"
if [ -f "$STARSHIP_CONF" ]; then
    ln -sf "$STARSHIP_CONF" "$HOME/.config/starship.toml"
fi

# Zen Browser - copy per-theme userChrome and restart if running
ZEN_CSS="$THEME_DIR/current/zen.css"
ZEN_PROFILE_RPATH=$(awk -F'=' '/^Default=/{prof=substr($0, index($0,"=")+1)} /^Locked=1/{if(prof!="") {print prof; exit}}' \
    "$HOME/.zen/installs.ini" 2>/dev/null)
if [ -n "$ZEN_PROFILE_RPATH" ] && [ -f "$ZEN_CSS" ]; then
    ZEN_CHROME_DIR="$HOME/.zen/$ZEN_PROFILE_RPATH/chrome"
    mkdir -p "$ZEN_CHROME_DIR"
    cp "$ZEN_CSS" "$ZEN_CHROME_DIR/userChrome.css"
    if pgrep -x zen-browser > /dev/null; then
        pkill -x zen-browser
        sleep 0.5
        zen-browser &>/dev/null &
    fi
fi

# Millennium (Steam) - update active theme; takes effect on next Steam restart
STEAM_THEME=$(cat "$THEME_DIR/current/steam-theme" 2>/dev/null | tr -d '[:space:]')
MILLENNIUM_CONFIG="$HOME/.local/share/Steam/millennium/config.json"
if [ -n "$STEAM_THEME" ]; then
    if [ -f "$MILLENNIUM_CONFIG" ]; then
        python3 -c "
import json, sys
with open('$MILLENNIUM_CONFIG') as f:
    cfg = json.load(f)
cfg.setdefault('themes', {})['activeTheme'] = '$STEAM_THEME'
with open('$MILLENNIUM_CONFIG', 'w') as f:
    json.dump(cfg, f, indent=4)
" 2>/dev/null || true
    else
        mkdir -p "$(dirname "$MILLENNIUM_CONFIG")"
        printf '{"themes":{"activeTheme":"%s","allowedStyles":true,"allowedScripts":true}}\n' "$STEAM_THEME" > "$MILLENNIUM_CONFIG"
    fi
fi

notify-send "Hyprland" "Theme: $CHOICE"
