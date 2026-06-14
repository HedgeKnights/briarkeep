#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PATH="$HOME/.local/bin:$PATH"
alias dot='cd ~/dotfiles && stow --restow hypr && cd -'
eval "$(starship init bash)"

export PATH=~/.npm-global/bin:$PATH
