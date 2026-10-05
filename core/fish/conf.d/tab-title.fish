if ! status is-interactive
    return
end

# Probed once per shell start. Without a working blf, titles fall back to the
# plain directory name and no herdr hooks are defined.
if blf tab-title >/dev/null 2>&1
    set -g _blf_tab_title_ok 1
else
    set -e _blf_tab_title_ok
end

function _title_text
    if set -q _blf_tab_title_ok
        blf tab-title "$argv[1]"
    else if test "$PWD" = "$HOME"
        echo "~"
    else
        basename $PWD
    end
end

function _set_tmux_pane_title
    set -q TMUX; or return

    set -l title (_title_text "$argv[1]")
    test -n "$title"; or return

    tmux select-pane -T "$title" >/dev/null 2>/dev/null
end

function fish_title
    if test -n "$TMUX"
        _set_tmux_pane_title "$argv[1]"
        return
    end

    _title_text "$argv[1]"
end

function _set_tmux_pane_title_on_prompt --on-event fish_prompt
    _set_tmux_pane_title
end

function _set_tmux_pane_title_on_preexec --on-event fish_preexec
    _set_tmux_pane_title "$argv[1]"
end

if set -q HERDR_ENV; and set -q _blf_tab_title_ok
    function _herdr_sync_tab_title_on_preexec --on-event fish_preexec
        blf herdr sync-tab-title --cmd "$argv[1]" 2>/dev/null &
        disown
    end

    function _herdr_sync_tab_title_on_prompt --on-event fish_prompt
        blf herdr sync-tab-title --prompt 2>/dev/null &
        disown
    end
end
