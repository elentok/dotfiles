function __fish_print_projects
  /bin/ls -1 ~/projects
end

complete --no-files -c p -a '(__fish_print_projects)'

