alias g 'git'
alias v 'nvim'

set user_and_host "$USER at" (hostname)

function fish_prompt
  echo

  set_color 555
  echo "$user_and_host" (date +\(%H:%M:%S\))

  set_color 3b78ff
  printf (pwd)

  set branch (git my-branch 2> /dev/null)
  if test -n "$branch"
    set_color fff
    printf ' at '

    set_color 14c60d
    echo "$branch"
  else
    echo
  end

  set_color 14c60d
  printf '› '
  set_color normal
end
