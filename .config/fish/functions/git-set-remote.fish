function git-set-remote
    # Usage:
    #   git-set-remote <fetch-url> <push-url>             # uses remote "origin"
    #   git-set-remote <remote> <fetch-url> <push-url>   # specify remote name
    set -l argc (count $argv)

    if test $argc -eq 2
        set -l remote origin
        set -l fetch_url $argv[1]
        set -l push_url  $argv[2]
    else if test $argc -eq 3
        set -l remote $argv[1]
        set -l fetch_url $argv[2]
        set -l push_url  $argv[3]
    else
        echo "Usage: git-set-remote [<remote>] <fetch-url> <push-url>"
        return 1
    end

    # ensure we're in a git repo (hide the normal "true" output)
    git rev-parse --is-inside-work-tree >/dev/null
    if test $status -ne 0
        echo "Error: not inside a Git repository."
        return 1
    end

    # If remote doesn't exist, add it with fetch_url and set push url
    git remote get-url $remote >/dev/null
    if test $status -ne 0
        echo "Remote '$remote' not found. Adding with fetch URL..."
        git remote add $remote $fetch_url
        if test $status -ne 0
            echo "Failed: git remote add $remote $fetch_url"
            return 1
        end
        git remote set-url --push $remote $push_url
        if test $status -ne 0
            echo "Failed: git remote set-url --push $remote $push_url"
            return 1
        end
    else
        # remote exists: set fetch and push URLs
        git remote set-url $remote $fetch_url
        if test $status -ne 0
            echo "Failed: git remote set-url $remote $fetch_url"
            return 1
        end
        git remote set-url --push $remote $push_url
        if test $status -ne 0
            echo "Failed: git remote set-url --push $remote $push_url"
            return 1
        end
    end

    echo "Remote '$remote' updated:"
    printf "  fetch: %s\n" (git remote get-url $remote)
    printf "  push : %s\n" (git remote get-url --push $remote)
end
