abbr --add g git
abbr --add gs 'git status'
abbr --add gl 'git log -n 10'
abbr --add gll 'git log'
abbr --add lg lazygit
abbr --add lgs 'lazygit status'
abbr --add lgl 'lazygit log'

function git-nf
    if test (count $argv) -eq 0
        echo "Usage: git-nf <new-branch-name>"
        return 1
    end

    cd (git-bare-root)
    set branch_name $argv[1]

    echo "About to create branch $(set_color green)$branch_name$(set_color normal)"
    echo "  in $PWD"
    echo
    read -P "$(set_color yellow)Are you sure$(set_color normal) [y/N]? " -n1 -l response

    if test "$response" != y
        return
    end

    echo creating

    git remote update upstream
    git worktree add -b "$branch_name" "$branch_name"
    cd "$branch_name"
    git reset --hard upstream/main
    direnv allow
end
