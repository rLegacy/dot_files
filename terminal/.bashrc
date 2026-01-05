# ~/.bashrc
if [ -f ~/.bash_secret_keys ]; then
    source ~/.bash_secret_keys
fi

[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Configuration
export EDITOR='nvim'

## uv
export PATH="/home/rlegacy/.local/bin:$PATH"
export DEVPOD_SKIP_CHOWN="true"

## Prompt
eval "$(starship init bash)"

# Aliases
alias wclone='git clone -c "core.sshCommand=ssh -i ~/.ssh/work -F /dev/null"'
alias python='uv run python'
