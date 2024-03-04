function complete_filename
    set filename "$(fd | fzf-tmux -p --exit-0)"
    if test -n "$filename"
        commandline -a "$filename"
        commandline -f end-of-line
    end
end

bind -M insert \ct complete_filename
