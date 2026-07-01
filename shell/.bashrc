#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- SSH prompt override (remove block to revert) ---
ssh() {
    printf '\033]0;⚠ SSH: %s\007' "$1"
    printf '\033]11;#2d1f23\007'
    STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml" command ssh "$@"
    printf '\033]111;\007'
    printf '\033]0;\007'
}
# ---

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
alias dot='cd ~/dotfiles && stow --restow gammastep ghostty gtk hypr nvim scripts shell systemd thunar waybar wofi vesktop && cd -'

command -v fastfetch &>/dev/null && fastfetch

eval "$(starship init bash)"

bpoff() { printf '\e[?2004l'; }
bpon() { printf '\e[?2004h'; }
