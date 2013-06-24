function __fish_print_tailr_logs
  tailr --list | tr ' ' '\n'
end

complete --no-files -c tailr -s l -l list -d "list available logs"
complete --no-files -c tailr -a '(__fish_print_tailr_logs)'
