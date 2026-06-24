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
- vesktop/ — Vesktop (Discord) theme; midnight-catppuccin-macchiato.theme.css in .config/vesktop/themes/, glass quickCss in .config/vesktop/settings/quickCss.css
- zen/ — Zen browser; active profile chrome at .zen/z7qc8h36.Default (release)/chrome/userChrome.css
- scripts/ — includes Steam Millennium themes at .local/share/Steam/millennium/themes/ (active: catppuccin-macchiato)

## Theme — glass + Catppuccin Macchiato
- Active theme: glass/hypr.lua (dofile'd from themes/current symlink → themes/glass)
- Per-app opacity rules in glass/hypr.lua: vesktop 0.92, zen 0.92, Spotify 0.92, steam 0.88
- Spotify: spicetify catppuccin theme, macchiato color scheme
- Font everywhere: JetBrains Mono Nerd Font

## System
- Arch Linux, Hyprland on Wayland
- AUR helper: yay
- Spotify installed via spotify-launcher (not pacman); binary at ~/.local/share/spotify-launcher/install/usr/share/spotify
