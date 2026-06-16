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
- htop/ — added; stow htop done

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

### Spicetify — done
First-time `spicetify apply` has been run. Theme switcher handles all future switches automatically.

### Obsidian — done
Snippets dir created and appearance.json wired up. Switcher copies obsidian.css on every theme switch.

### Next up
- Discord — Vencord AUR package installed; needs VencordInstaller run to inject into Discord binary,
  then `~/.config/Vencord/` will exist. Add per-theme CSS files and a copy step in the switcher
  (same pattern as Obsidian). quickCss path: ~/.config/Vencord/settings/quickCss.css
- Notifications — theme mako (Wayland notification daemon). Per-theme config or color overrides
  written to ~/.config/mako/config on switch, then `makoctl reload`.
- Login screen — clarify target: SDDM theme vs greetd. Apply per-system-theme on switch or as
  a one-time aesthetic choice separate from the runtime theme switcher.

### Deferred
- Steam — needs Millennium, complex
- Zen browser — deferred
- Kitty — low priority (backup terminal), trivial to add when wanted
