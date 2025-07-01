fnm env --use-on-cd --shell fish | source

# By default fnm adds it's path at the end so the Node that comes with homebrew
# takes precedence. To avoid that I'm prepending it afterwards.
# fish_add_path --prepend "$FNM_MULTISHELL_PATH/bin"

# fnm creates a new file on every session, this tries to clean it up
function fnm_clean_up --on-event fish_exit
    rm -r $FNM_MULTISHELL_PATH
end
