function __fish_print_vim_plugins
  /bin/ls -1 $DOTF/vim/bundle/
end

complete --no-files -c vimp -a '(__fish_print_vim_plugins)'

