function dt --description "deno task"
    if test (count $argv) -gt 0
        bun run $argv
    else
        set cmd "$(deno-tasks | fzf-tmux -p -w 80% --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            commandline --replace "deno task "$cmd""
            commandline -f execute
        end
    end
end

function deno-tasks
    deno task 2>&1 \
        | grep -v 'Available tasks:' \
        | tr '\n' '\r' \
        | sed -e 's/\r    / => /g' \
        | tr '\r' '\n' \
        | sed 's/^- //'
end
