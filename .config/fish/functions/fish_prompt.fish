function fish_prompt
    # Enable timing info globally (put this once in your config.fish to make sure)
    set -g __fish_command_duration 1

    set_color cyan
    echo -n (whoami)"@"(hostname -s)" "

    set_color yellow
    echo -n (prompt_pwd)" "

    set_color blue
    set pyfiles *.py
    if test -f pyproject.toml -o -f requirements.txt -o (count $pyfiles) -gt 0
        echo -n "Python "(python3 --version 2>/dev/null | string match -r '[0-9.]+')
    else if test -f Cargo.toml
        echo -n "Rust "(rustc --version 2>/dev/null | string match -r '[0-9.]+')
    else if test -f package.json
        echo -n "Node "(node --version 2>/dev/null)
    else if test -f go.mod
        echo -n "Go "(go version 2>/dev/null | string match -r 'go[0-9.]+')
    end
    echo -n " "

    set_color green
    if git rev-parse --is-inside-work-tree 2>/dev/null | grep -q 'true'
        set branch (git symbolic-ref --short HEAD 2>/dev/null)
        set dirty (git status --porcelain 2>/dev/null)
        echo -n "git:("$branch
        if test -n "$dirty"
            echo -n " *"
        end
        echo -n ") "
    end

    set_color magenta
    if test $__fish_last_command_duration
        echo -n "["$__fish_last_command_duration"s] "
    end

    echo ""
    set_color normal
    echo -n "> "
end

