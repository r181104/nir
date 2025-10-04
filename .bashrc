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
# export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\] ✦ '

export HISTSIZE=5000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

bind "set completion-ignore-case on"

function __git_ps1() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && return
  local dirty=""
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    dirty="*"
  fi
  printf "$branch$dirty"
}

function __failed_cmd {
  if [[ $? -eq 0 ]]; then
    printf "\033[32m✓"
  else
    printf "\033[31m✘"
  fi
}

GREEN="\[\033[32m\]"
BLUE="\[\033[34m\]"
MAGENTA="\[\033[35m\]"
RESET="\[\033[0m\]"
RED="\[\033[31m\]"

PS1="${GREEN}\u"
PS1+="${BLUE}  \W"
PS1+="${MAGENTA} \$(__git_ps1 ' (%s )')\n"
PS1+="$(__failed_cmd) "
PS1+="${RESET}"
