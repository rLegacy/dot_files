# ~/.bashrc
if [ -f ~/.bash_secret_keys ]; then
    source ~/.bash_secret_keys
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Configuration
export EDITOR='nvim'

## Prompt
eval "$(starship init bash)"
