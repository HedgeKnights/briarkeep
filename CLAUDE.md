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

## System
- Arch Linux, Hyprland on Wayland
- AUR helper: yay
- Spotify installed via spotify-launcher (not pacman); binary at ~/.local/share/spotify-launcher/install/usr/share/spotify
