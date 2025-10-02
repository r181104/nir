function __lang_version_cache --argument lang cmd file
    if test -e $file
        if not set -q __cached_$lang
            set -g __cached_$lang (eval $cmd)
        end
        echo "$lang$__cached_$lang "
    end
end

function fish_prompt
    # Duration
    set -l dur ""
    if set -q _fish_last_cmd_start
        set -l d (math (date +%s) - $_fish_last_cmd_start 2>/dev/null)
        if test $d -ge 1
            set_color FF8800  # aurora orange
            set dur "[$d s]"
            set_color normal
        end
    end

    # Language versions if project files exist
    set -l langs ""
    set_color 8FBCBB  # aurora green
    set langs "$langs"(__lang_version_cache py "python3 --version | awk '{print \$2}'" pyproject.toml requirements.txt)
    set langs "$langs"(__lang_version_cache node "node -v | string trim -c v" package.json)
    set langs "$langs"(__lang_version_cache go "go version | awk '{print \$3}' | string trim -c go" go.mod)
    set_color normal

    # Git info
    set -l git_info (__fish_git_prompt " (%s)")

    # --- Top line ---
    set_color 88C0D0  # frost cyan
    echo -n (whoami)"@"(hostname)" "
    set_color 81A1C1  # frost blue
    echo -n (pwd)
    set_color B48EAD  # aurora purple
    echo -n $git_info
    set_color 8FBCBB  # aurora green
    echo -n " "$langs
    set_color FF8800  # aurora orange
    echo -n " "$dur
    set_color normal
    echo

    # --- Bottom line ---
    set_color 88C0D0  # frost cyan
    echo -n "❯ "
    set_color normal
end

# Track command start time
function fish_preexec --on-event fish_preexec
    set -g _fish_last_cmd_start (date +%s)
end

# Blank line after each execution
function fish_postexec --on-event fish_postexec
    echo
end
