# ============================
# PATH setup (keep all system commands)
# ============================
export PATH="$HOME/.local/bin:$HOME/.local/sbin:$PATH"

# ============================
# Only run for interactive shells
# ============================
[[ $- != *i* ]] && return

# ============================
# Aliases
# ============================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias n='nvim'
alias nv='neovide'
alias sn='sudo nvim'

# ============================
# Prompt
# ============================
export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\] ✦ '
