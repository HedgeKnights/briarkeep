# Dotfiles - Claude Code Instructions

## Structure
- Stow-based dotfiles repo at ~/dotfiles
- Each directory is a stow package that symlinks to ~/.config
- Source of truth is ~/dotfiles — never edit ~/.config directly

## Key packages
- hypr/ — Hyprland WM config, themes, scripts
- wofi/ — app launcher
- waybar/ — status bar
- ghostty/ — terminal (primary), kitty kept as backup (skip for now)
- nvim/ — neovim with lazy.nvim
- shell/ — bashrc, starship, gitconfig
- gtk/, gammastep/, thunar/, systemd/
- btop/ — added; stow btop done
- htop/ — added; needs `stow htop` (sandbox blocked it)

## Rules
- Always edit files in ~/dotfiles, not ~/.config
- After adding a new package, run: stow <packagename>
- Commit changes after completing a task with a descriptive message

## System
- Arch Linux, Hyprland on Wayland
- Username: hedgeknight
- AUR helper: yay
- Spotify installed via spotify-launcher (not pacman); binary at ~/.local/share/spotify-launcher/install/usr/share/spotify

## Theme switcher — hypr/scripts/theme-switcher.sh
Each theme dir (catppuccin, forest, glass, minimal) under hypr/themes/ contains hint files read by the switcher.

### Wired up and working
- hypr.conf, waybar.css, wofi.css — symlinked on switch
- ghostty-theme, nvim-theme — hot-reload via signal/remote-send
- btop-theme — edits btop.conf, sends SIGUSR1
- htop-colorscheme — edits htoprc (takes effect on next htop launch)
- gtk-theme — edits gtk-3.0/settings.ini + gsettings
- spotify-theme — spicetify config + apply (THEME:COLOR_SCHEME format)
- obsidian.css — copied to ~/Obsidian_Tower/.obsidian/snippets/active-theme.css on switch

### Waybar note
Waybar reload was changed from SIGUSR2 (toggled visibility) to kill+restart. Brief ~0.2s flash on switch is expected.

### Forest waybar fix
Background was rgba(26,35,24) — too dark, looked black. Changed to rgba(42,60,35).

### Spotify theme mappings
- catppuccin → catppuccin:mocha
- forest → Dribbblish:dark
- glass → Sleek:Deeper
- minimal → Matte:rose-pine-moon

### Spicetify — needs one manual step
Spicetify is installed and configured but Spotify has never been patched. Run:
```
spicetify apply
```
After that the theme switcher handles it automatically on every switch.

### Obsidian — needs one-time setup
Snippets directory and appearance.json need to be initialised once:
```
mkdir -p ~/Obsidian_Tower/.obsidian/snippets
jq '. + {"enabledCssSnippets": ["active-theme"]}' \
  ~/Obsidian_Tower/.obsidian/appearance.json > /tmp/appearance.json && \
  mv /tmp/appearance.json ~/Obsidian_Tower/.obsidian/appearance.json
```
After that the switcher copies obsidian.css into the snippets dir and Obsidian hot-reloads it.

### Next up
- Discord — needs Vencord installed first, then CSS per theme (same copy pattern as Obsidian)

### Deferred
- Steam — needs Millennium, complex
- Zen browser — deferred
- Kitty — low priority (backup terminal), trivial to add when wanted

### Commit needed in ~/dotfiles
Everything is staged but not committed. Run:
```
cd ~/dotfiles
git add -A
git commit -m "extend theme switcher: btop, htop, GTK, Spicetify, Obsidian"
```
