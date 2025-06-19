function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert

    bind -M default gl end-of-line
    bind -M default gs beginning-of-line

    bind -M visual -m default y fish_copy_and_cancel
    bind p fish_clipboard_paste

    bind -M insert -m default jk backward-char force-repaint
    bind -M insert -m default jl backward-char force-repaint
    # bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

function fish_copy_and_cancel
    fish_clipboard_copy
    commandline -f end-selection
end

set -gx FZF_DEFAULT_OPTS "--tmux=center,85%,70%"
# fzf --fish | source
