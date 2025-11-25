# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Configuration
export EDITOR='nvim'
# Aliases
alias v=' NVIM_APPNAME=nvimLazyvim nvim'
# Prompt
eval "$(starship init bash)"
