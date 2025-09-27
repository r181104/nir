function man --description "Pretty man pages with bat when available"
    if type -q bat
        command man $argv | col -bx | bat -l man --paging=always
    else
        command man $argv
    end
end
