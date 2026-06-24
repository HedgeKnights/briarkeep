# Theme Switcher Skill

Script: `hypr/scripts/theme-switcher.sh`
Themes: `hypr/themes/{catppuccin,forest,glass,minimal}/` — each dir contains hint files read by the switcher.

## What's wired (switches on every theme change)

- `hypr.conf`, `waybar.css`, `wofi.css` — symlinked
- `ghostty-theme`, `nvim-theme` — hot-reloaded via signal/remote-send
- `btop-theme` — edits `btop.conf`, sends SIGUSR1
- `htop-colorscheme` — edits `htoprc` (takes effect on next htop launch, not live)
- `gtk-theme` — edits `gtk-3.0/settings.ini` + gsettings
- `spotify-theme` — spicetify config + apply (`THEME:COLOR_SCHEME` format)
- `obsidian.css` — copied to `~/Obsidian_Tower/.obsidian/snippets/active-theme.css`
- `discord.css` — copied to `~/.config/vesktop/settings/quickCss.css`; Vesktop is killed+relaunched (Vencord does NOT hot-reload quickCss from disk)
- `hyprlock.conf` — per-theme file symlinked to `~/.config/hypr/hyprlock.conf`; takes effect at next lock
- `starship.toml` — per-theme file symlinked to `~/.config/starship.toml`; takes effect at next prompt
- `dunst-colors.conf` — symlinked and reloaded via `dunstctl reload`

<!-- Forest theme waybar background was originally rgba(26,35,24) — too dark; changed to rgba(42,60,35) -->
<!-- Spicetify first-time `spicetify apply` run manually; theme switcher handles all future switches -->
<!-- Obsidian snippets dir and appearance.json wired up manually; switcher copies obsidian.css on every switch -->

## Waybar reload
Uses kill+restart (not SIGUSR2). Brief ~0.2s flash on switch is expected.

## Spotify theme mappings
- catppuccin → catppuccin:mocha
- forest → Dribbblish:dark
- glass → Sleek:Deeper
- minimal → Matte:rose-pine-moon

## hyprlock / hypridle
- hyprlock: blurred screenshot bg, clock/date overlay, catppuccin input field
- hypridle: 4min dim, 5min lock, 10min suspend; exec-once in hyprland.conf

## Sleep keybindings
- Super+L — lock screen (hyprlock)
- Super+Shift+Escape — suspend immediately

## SDDM login screen
Not wired into the theme switcher — one-time manual setup (requires sudo):
```sh
sudo mkdir -p /etc/sddm.conf.d && sudo sh -c 'echo "[Theme]\nCurrent=maldives" > /etc/sddm.conf.d/theme.conf'
sudo cp ~/Images/wallpapers/catppuccin.jpg /usr/share/sddm/themes/maldives/background.jpg
```
Current: maldives theme + catppuccin.jpg wallpaper.

## GTK theme variants
- catppuccin → `catppuccin-mocha-mauve-standard+default` (mauve accent matches waybar/hypr palette)
- forest → `Adwaita-dark` (no forest GTK theme available)
- glass → `Adwaita-dark`
- minimal → `rose-pine-moon-gtk`

## Spicetify notes
Themes live in `~/.config/spicetify/Themes/`: catppuccin (catppuccin/spicetify), Dribbblish/Sleek/Matte (spicetify/spicetify-themes).
`overwrite_assets = 1` required globally (catppuccin and Dribbblish both have `assets/` dirs).
`inject_theme_js = 1` required globally (catppuccin and Dribbblish both have `theme.js`).

## Not wired — deferred
- **Steam**: needs Millennium — deferred (complex)
- **Zen browser**: deferred
- **Kitty**: low priority backup terminal, trivial to add when wanted
