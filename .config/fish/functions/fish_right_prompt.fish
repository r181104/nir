function fish_right_prompt
    # Error code
    if test $status -ne 0
        set_color red
        echo -n "✘$status "
    end

    # Command duration if >1s
    if test $CMD_DURATION -gt 1000
        set_color yellow
        echo -n (math -s0 $CMD_DURATION/1000)"s"
    end

    set_color normal
end
