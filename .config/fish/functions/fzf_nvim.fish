function fzf_nvim
    set -l selected_file (fzf --reverse --ansi \
        --prompt="📝 Open in nvim: " \
        --preview 'eza --icons --color=always --long --git --group --modified {} 2>/dev/null' \
        --preview-window=right:60%:wrap)

    if test -n "$selected_file"
        nvim "$selected_file"
        commandline -f repaint
    end
end
