set -g fish_start_time (date +%s%N)

function report_fish_startup_time --on-event fish_prompt
    set -g fish_end_time (date +%s%N)
    set -g elapsed_time (math "($fish_end_time - $fish_start_time) / 1000000")
    echo -e "\x1b[38;5;241m $(printf '%.2f' $elapsed_time)ms\033[0m"
    functions --erase report_fish_startup_time # Remove function after first run
end

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
