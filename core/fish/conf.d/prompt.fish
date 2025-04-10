if ! status is-interactive
    return
end

set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_showcolorhints no
set -g __fish_git_prompt_showupstream git
set -g __fish_git_prompt_char_upstream_ahead "$(set_color blue) "
set -g __fish_git_prompt_char_upstream_behind "$(set_color yellow) "
set -g __fish_git_prompt_char_upstream_diverged "$(set_color red)󰋔 "
set -g __fish_git_prompt_char_upstream_equal "󰋑 "
set -g __fish_git_prompt_char_dirtystate "$(set_color red)󰪢 "
set -g __fish_git_prompt_char_stagedstate "$(set_color green)󰗡 "

set __prompt_bgs 2b2b3c 181825 2b2b3c 3e5767
set __prompt_fgs 9399b2 9399b2 9399b2 9399b2
set __prompt_block_index 0

function fish_prompt
    set -l last_status $status
    set __prompt_block_index 0

    echo

    string join '' -- \
        (__prompt_block ' 󰉖 ' (prompt_pwd --full-length-dirs 5)) \
        (__prompt_vcs_block) \
        (__prompt_host_block) \
        (__prompt_separator --final)

    if test $last_status -eq 0
        string join '' -- (set_color green) '󰄾 ' (set_color normal)
    else
        string join '' -- (set_color red) '󰄾 ' (set_color normal)
    end
end

function __prompt_vcs_block
    set content (fish_vcs_prompt)

    if test -n "$content"
        set content (string trim $content --chars=" ()")
        __prompt_block ' ' $content
    end
end

function __prompt_host_block
    if test -n "$SSH_CONNECTION"
        __prompt_block '   ' (hostname)
    end
end

function __prompt_block
    if test $__prompt_block_index -gt 0
        __prompt_separator
    end

    set __prompt_block_index (math $__prompt_block_index + 1)
    set bgcolor $__prompt_bgs[$__prompt_block_index]
    set fgcolor $__prompt_fgs[$__prompt_block_index]

    string join '' -- \
        (set_color -b $bgcolor $fgcolor) \
        $argv \
        ' ' \
        (set_color normal)
end

function __prompt_separator
    set bgcolor $__prompt_bgs[(math $__prompt_block_index + 1)]
    set fgcolor $__prompt_bgs[(math $__prompt_block_index)]
    if test "$argv[1]" = --final
        set bgcolor normal
    end

    string join '' -- \
        (set_color -b $bgcolor $fgcolor) \
        ' ' \
        (set_color normal)
end
