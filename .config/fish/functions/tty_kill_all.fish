function tty_kill_all
    set -l curtty (basename (tty))
    set -l ttys (who | awk '{print $2}' | grep -E '^(tty[0-9]+|pts/[0-9]+)$' | grep -v "^$curtty\$" | sort -u)
    if test (count $ttys) -gt 0
        set -l tty_csv (string join , $ttys)
        echo "Targets: $tty_csv"
        echo "Processes that would be signalled:"
        pgrep -a -t "$tty_csv" || echo "(no matching processes shown)"
        read -P "Proceed and send SIGTERM to these processes? (y/N) " answer
        if test "$answer" = "y"
            sudo pkill -t "$tty_csv"
            sleep 1
            if pgrep -a -t "$tty_csv" >/dev/null
                echo "Some processes remain; sending SIGKILL..."
                sudo pkill -9 -t "$tty_csv"
            end
            echo "Done."
        else
            echo "Aborted."
        end
    else
        echo "No other TTYs found (excluding current: $curtty)."
    end
end
