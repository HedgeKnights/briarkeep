#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
alias dot='cd ~/dotfiles && stow --restow gammastep ghostty gtk hypr nvim scripts shell systemd thunar waybar wofi vesktop && cd -'

command -v fastfetch &>/dev/null && fastfetch

eval "$(starship init bash)"

bpoff() { printf '\e[?2004l'; }
bpon() { printf '\e[?2004h'; }
