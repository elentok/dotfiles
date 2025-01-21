fnm env --use-on-cd --shell fish | source

# By default fnm adds it's path at the end so the Node that comes with homebrew
# takes precedence. To avoid that I'm prepending it afterwards.
fish_add_path --prepend "$FNM_MULTISHELL_PATH/bin"
