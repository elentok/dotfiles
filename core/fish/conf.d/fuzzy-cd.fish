function d
    set dir "$(list-dirs --maxdepth 6 | fzf-tmux --ansi --exit-0 --select-1)"

    if test -n "$dir"
        commandline --replace "cd "$dir""
        commandline -f execute
    end
end

# Usage: list-dirs [optional: root]
function list-dirs
    set _flag_maxdepth 1
    argparse 'm#maxdepth' -- $argv

    if test (count $argv) -gt 0
        set root $argv
    else
        set root $(pwd)
    end

    begin
        cd "$root" && find . -maxdepth $_flag_maxdepth -type d
    end | sed 's#^\.\/##' | grep -v '^\.$' || true
end
