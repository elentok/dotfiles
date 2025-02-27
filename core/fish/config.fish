if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

set fish_key_bindings fish_user_key_bindings
# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line

if status is-interactive
    set fish_greeting ""
    # function fish_greeting
    #     if type -q pfetch
    #         pfetch
    #     else
    #         echo "==> Can't show greeting, 'pfetch' is missing"
    #     end
    # end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# jumper
# jumper shell fish | source

for dir in ~/.dotplugins/*
    if test -e "$dir/fish/config.fish"
        source "$dir/fish/config.fish"
    end
end
