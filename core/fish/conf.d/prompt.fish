if ! status is-interactive
    return
end

set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_showcolorhints yes

function fish_prompt
    set -l last_status $status

    echo

    string join '' -- \
        (set_color blue) (prompt_pwd --full-length-dirs 5) (set_color normal) \
        (fish_vcs_prompt) \
        ' ' (prompt_login)


    if test $last_status -eq 0
        string join '' -- (set_color green) '󰄾 ' (set_color normal)
    else
        string join '' -- (set_color red) '󰄾 ' (set_color normal)
    end
end
