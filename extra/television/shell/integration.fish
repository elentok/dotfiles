function tv_smart_autocomplete
    # prefix (lhs of cursor)
    set -l current_prompt (commandline -cp)

    set -l output (tv --autocomplete-prompt "$current_prompt")

    if test -n "$output"
        # add a space if the prompt does not end with one (unless the prompt is an implicit cd, e.g. '\.')
        string match -q -r '.*( |./)$' -- "$current_prompt" || set output " $output"
        commandline -i "$output"
        commandline -f repaint
    end
end

function tv_shell_history
    set -l current_prompt (commandline -cp)

    set -l output (tv fish-history --input "$current_prompt")

    if test -n "$output"
        commandline -r "$output"
        commandline -f repaint
    end
end

bind -M insert \cT tv_smart_autocomplete
bind -M insert \cR tv_shell_history

