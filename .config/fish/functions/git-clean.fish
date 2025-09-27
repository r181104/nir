function git-clean --description "Clean and shrink .git directory (use --hard for destructive cleanup)"
    if not test -d .git
        echo "❌ Not inside a Git repository."
        return 1
    end

    if test (count $argv) -gt 0
        switch $argv[1]
            case --hard
                echo "⚠️  HARD CLEANUP: This rewrites history and may break shared repos."
                echo "   Backup first! Press Ctrl+C to abort."
                read -P "Continue? (y/N) " confirm
                if test "$confirm" != "y" -a "$confirm" != "Y"
                    echo "❎ Aborted hard cleanup."
                    return
                end

                # Check for large files
                set large_files (git rev-list --objects --all | \
                    git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
                    awk '$1 == "blob" && $3 > 10485760 {print $3/1048576 " MB\t" $4}' )

                if test -n "$large_files"
                    echo "🚨 Large files found in history:"
                    echo "$large_files"
                else
                    echo "✅ No blobs larger than 10MB found."
                end

                # Perform cleanup if tools are available
                if type -q git-filter-repo
                    git filter-repo --strip-blobs-bigger-than 10M --force
                    echo "✅ git-filter-repo cleanup complete."
                else if type -q bfg
                    bfg --strip-blobs-bigger-than 10M
                    git reflog expire --expire=now --all
                    git gc --prune=now --aggressive
                    echo "✅ BFG cleanup complete."
                else
                    echo "❌ Neither git-filter-repo nor BFG installed. Cannot do hard cleanup."
                end
            case '*'
                echo "Unknown option: $argv[1]"
                echo "Usage: git-clean [--hard]"
        end
    else
        echo "🧹 Performing safe cleanup..."
        git reflog expire --expire=now --all
        git gc --prune=now --aggressive
        echo "✅ Safe cleanup complete!"
    end
end
