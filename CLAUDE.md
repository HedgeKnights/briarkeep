# Dotfiles - Claude Code Instructions

## Rules
- Stow-based dotfiles repo at ~/dotfiles — each package dir symlinks into ~/.config
- Always edit files in ~/dotfiles, never ~/.config directly
- After adding a new package, run: stow <packagename>
- Commit changes after completing a task with a descriptive message

## Key packages
- hypr/ — Hyprland WM config, themes, scripts
- wofi/ — app launcher; waybar/ — status bar
- ghostty/ — primary terminal; kitty/ — backup, skip for now
- nvim/ — neovim (lazy.nvim); shell/ — bashrc, starship, gitconfig
- gtk/, gammastep/, thunar/, systemd/, btop/, htop/
- vesktop/ — Vesktop (Discord); midnight-catppuccin-macchiato.theme.css in .config/vesktop/themes/ (Vencord auto-loads as base structural theme), color overrides in .config/vesktop/settings/quickCss.css (managed by theme-switcher)
- zen/ — Zen browser; ~/.zen is a whole-dir symlink to dotfiles/zen/.zen; active profile: z7qc8h36.Default (release); userChrome.css + user.js live at .zen/z7qc8h36.Default (release)/chrome/ and .zen/z7qc8h36.Default (release)/
- scripts/ — Steam Millennium themes at .local/share/Steam/millennium/themes/ (active: catppuccin-mocha); themes dir shares inodes with dotfiles so writes to dotfiles go live immediately

## Theme — glass + Catppuccin Mocha
- Active theme: glass/hypr.lua (dofile'd from themes/current → themes/glass)
- Per-app opacity rules in glass/hypr.lua: vesktop 0.92, zen 0.92, Spotify 0.92, steam 0.88
- Spotify wm_class is "Spotify" (capital S) — lowercase window rules won't match
- Zen: Transparent Zen mod (v1.17.16) installed and enabled; user.js sets browser.tabs.allow_transparent_browser and zen.widget.linux.transparency = true for real compositor glass
- Spotify: spicetify catppuccin theme, mocha color scheme (Glassify CDN is dead — not installable)
- Font everywhere: JetBrains Mono Nerd Font

## System
- Arch Linux, Hyprland on Wayland
- AUR helper: yay
- Spotify installed via spotify-launcher (not pacman); binary at ~/.local/share/spotify-launcher/install/usr/share/spotify
