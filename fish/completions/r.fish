function __fish_print_rubies
  /bin/ls -1 ~/.rvm/rubies
end

complete --no-files -c r -a '(__fish_print_rubies)'

