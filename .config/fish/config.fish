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
set -gx BROWSER "firefox"
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
alias ffind "sk --preview='bat {}' --bind 'enter:execute(nvim {})'"
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
#   SKIM AND ZOXIDE
# ==============================
if command -q sk
    bind \er find_file
    bind \et sk
end

if command -q zoxide
    zoxide init fish | source
end

# Lightweight zoxide seeding including important hidden dirs
function __zoxide_seed --on-event fish_prompt
    set seed_dir ~/.local/share/zoxide
    set db_file $seed_dir/.dirs_db

    mkdir -p $seed_dir

    # top-level dirs + important hidden dirs
    set -l dirs (find $HOME -maxdepth 1 -type d \
        -not -path "$HOME/.cache" \
        -not -path "$HOME/.local/share" \
        -not -path "$HOME/Downloads" \
        -not -path "$HOME/Trash" \
        -not -path "$HOME/.mozilla" \
        -not -path "$HOME/.thunderbird" \
        -not -path "$HOME/.steam" \
    )
    set -l hidden_dirs "$HOME/.config" "$HOME/.local/bin" "$HOME/.ssh"

    set dirs $dirs $hidden_dirs

    # create db file if missing
    if not test -f $db_file
        touch $db_file
    end

    set -l existing_dirs (cat $db_file)

    # only new dirs
    set -l new_dirs
    for d in $dirs
        if not contains $d $existing_dirs
            set new_dirs $new_dirs $d
        end
    end

    if test (count $new_dirs) -gt 0
        # background seeding
        for d in $new_dirs
            nohup zoxide add $d >/dev/null 2>&1 &
        end
        printf "%s\n" $new_dirs >> $db_file
    end
end
