if status is-interactive
    if command -q fastfetch
        fastfetch --config my
        alias fetch "fastfetch --config my"
    end
end

# NOTE: ==============================
#   Core Environment Variables
# ==============================
set -gx LANG en_IN.UTF-8
set -gx BROWSER "brave"
set -gx TERM "alacritty"
set -gx EDITOR "neovide"
set -gx COLORTERM "truecolor"
set -gx LS_COLORS "di=1;34:fi=0"
# NOTE: set -gx LS_COLORS "di 1;3;34:fi=0"

# NOTE: Ensure PATH exists
set -q PATH; or set PATH

# NOTE: User paths (prepended)
for p in $HOME/.local/bin $HOME/.local/sbin
    if not contains $p $PATH
        set -p PATH $p
    end
end

# NOTE: System paths (appended)
for p in /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin
    if not contains $p $PATH
        set -a PATH $p
    end
end

# NOTE: Java environment (auto-detect JDK)
# set -Ux JAVA_HOME (archlinux-java get | string replace 'java-' '/usr/lib/jvm/java-')
# set -Ux PATH $JAVA_HOME/bin $PATH

# NOTE: ==============================
#   Auth & Agents
# ==============================
if type -q keychain
    keychain --quiet --eval ~/.ssh/id_rsa | source
end

# NOTE: ==============================
#   Prompt (Starship)
# ==============================
if command -q starship
    starship init fish | source
end

# NOTE: ==============================
#   Key Bindings
# ==============================
set -g fish_key_bindings fish_default_key_bindings
bind \en down-or-search
bind \ep up-or-search

# NOTE: ==============================
#   Package Manager aliases
# ==============================
if type -q paru
    alias i 'paru --noconfirm --needed -S'
    alias u 'paru --noconfirm -Syu'
    alias r 'paru -Rns'
    alias s 'paru -Ss'
    alias remove-orphaned 'sudo pacman -Rns (pacman -Qtdq) && paru -Rns (pacman -Qtdq)'
    alias aggressively-clear-cache 'sudo pacman -Scc && paru -Scc'
    alias clear-cache 'sudo pacman -Sc && paru -Sc'
else if type -q yay
    alias i 'yay --noconfirm --needed -S'
    alias u 'yay --noconfirm -Syu'
    alias r 'yay -Rns'
    alias s 'yay -Ss'
    alias remove-orphaned 'sudo pacman -Rns (pacman -Qtdq) && yay -Rns (pacman -Qtdq)'
    alias aggressively-clear-cache 'sudo pacman -Scc && yay -Scc'
    alias clear-cache 'sudo pacman -Sc && yay -Sc'
else
    alias i 'sudo pacman --noconfirm --needed -S'
    alias u 'sudo pacman --noconfirm -Syu'
    alias r 'sudo pacman -Rns'
    alias s 'sudo pacman -Ss'
    alias remove-orphaned 'sudo pacman -Rns (pacman -Qtdq)'
    alias aggressively-clear-cache 'sudo pacman -Scc'
    alias clear-cache 'sudo pacman -Sc'
end

# NOTE: ==============================
#   General aliases
# ==============================
# NOTE: Navigation
alias home 'cd ~'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias c 'clear'

# NOTE: Editors
alias n 'nvim'
alias nv 'neovide'
alias sn 'sudo nvim'
alias snd 'sudo neovide'
alias v 'vim'
alias sv 'sudo vim'

# NOTE: Tmux
alias tns 'tmux new -s'
alias ta 'tmux attach'
alias td 'tmux detach'

# NOTE: System helpers
alias ps 'ps auxf'
alias ping 'ping -c 5'
alias less 'less -R'
alias h "history | grep "
alias p "ps aux | grep "
alias topcpu "ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias ffind "fzf --preview='bat {}' --bind 'enter:execute(nvim {})'"
alias f "find . | grep "
alias openports 'netstat -tulanp'

# NOTE: System control
alias reboot 'systemctl reboot'
alias shutdown 'shutdown now'
alias logout 'loginctl kill-session $XDG_SESSION_ID'
alias restart-dm 'sudo systemctl restart display-manager'

# NOTE: File operations
alias cp 'cp -i'
alias mv 'mv -i'
alias mkdir 'mkdir -p'
alias rmd '/bin/rm -rfv'

# NOTE: Disk usage
alias diskspace "du -S | sort -n -r | less"
alias folders 'du -h --max-depth=1'
alias mountedinfo 'df -hT'
alias duf 'duf -hide special'

# NOTE: Permissions & security
alias mx 'chmod a+x'
alias 000 'chmod -R 000'
alias 644 'chmod -R 644'
alias 666 'chmod -R 666'
alias 755 'chmod -R 755'
alias 777 'chmod -R 777'
alias sha1 'openssl sha1'
alias chown 'sudo chown -R $USER'

# NOTE: Dev & tools
alias grep 'grep --color=auto'
alias rg 'rg --color=auto'
alias bright 'brightnessctl set'

# NOTE: Git helpers
alias gp 'git push'

# NOTE: Programming helpers
alias pyr 'python'

# NOTE: Utilities
alias kssh "kitty +kitten ssh"
alias web 'cd /var/www/html'
alias da 'date "+%Y-%m-%d %A %T %Z"'

# NOTE: LLMS
alias llama-chat "llama-simple-chat -m ~/LLMS/qwen2.5-0.5b-instruct-q4_k_m.gguf -ngl 12"
alias llama-server "llama-server -m ~/LLMS/qwen2.5-0.5b-instruct-q4_k_m.gguf -ngl 12"

# NOTE: Terminal based browser
alias tb "BROWSER=w3m ddgr"

# NOTE: Python Server
alias phs "python -m http.server"
alias phsd "python -m http.server --directory"

# NOTE: ==============================
#   File Listing (eza / ls)
# ==============================
if type -q eza
    alias ls    'eza -a --icons'
    alias l     'eza -a --icons'
    alias la    'eza -a --icons -l'
    alias ll    'eza -a --icons -l'
    alias lx    'eza -a --icons -l --sort=extension'
    alias lk    'eza -a --icons -l --sort=size'
    alias lc    'eza -a --icons -l --sort=changed'
    alias lu    'eza -a --icons -l --sort=accessed'
    alias lr    'eza -a --icons -l -R'
    alias lt    'eza -a --icons -l --sort=modified'
    alias lm    'eza -a --icons -l | less'
    alias lw    'eza -a --icons -x'
    alias labc  'eza -a --icons --sort=name'
    alias tree  'eza -a --icons --tree'
else
    alias ls    'ls -A --color=auto'
    alias l     'ls -A --color=auto'
    alias la    'ls -lhA --color=auto'
    alias ll    'ls -lhA --color=auto'
    alias lx    'ls -lhA --color=auto'
    alias lk    'ls -lhAS --color=auto'
    alias lc    'ls -lhAt --color=auto'
    alias lu    'ls -lhAu --color=auto'
    alias lr    'ls -lhAR --color=auto'
    alias lt    'ls -lhAt --color=auto'
    alias lm    'ls -lhA --color=auto | less'
    alias lw    'ls -xA --color=auto'
    alias labc  'ls -lhA --color=auto'
    alias tree  'ls -R --color=auto'
end

# NOTE: ==============================
#   FZF
# ==============================
if command -q fzf
    bind \er fzf_nvim
    bind \ed fzf-cd-widget
    bind \et fzf
end

# Auto-start X on TTY1, once per login
if status --is-interactive; and not set -q DISPLAY; and tty | grep -q '/dev/tty1'; and not set -q SSH_CONNECTION
    if not test -f /tmp/.xsession_started_$USER
        touch /tmp/.xsession_started_$USER
        startx >/dev/null 2>&1 || echo "startx failed, check ~/.xsession-errors"
    end
end
