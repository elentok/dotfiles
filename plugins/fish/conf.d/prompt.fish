set user_and_host "$USER at" (hostname)

set EL_GRAY 555753
set EL_BLUE 729fce
set EL_GREEN 8ae234
set EL_RED ef2929
set EL_WHITE fff

function fish_prompt
  set -l exit_code $status
  echo

  # line 1
  set_color -o $EL_GRAY
  echo "$user_and_host" (date +\(%H:%M:%S\))

  # line 2
  set_color -o $EL_BLUE
  echo -n (pwd | sed -e "s|^$HOME|~|")
  fish_prompt_git
  echo

  # line 3
  if test $exit_code = 0
    set_color -o $EL_GREEN
  else
    set_color -o $EL_RED
  end
  echo -n '› '
  set_color normal
end

function fish_prompt_git
  set -l is_git_repository (git rev-parse --is-inside-work-tree ^/dev/null)
  if test -z "$is_git_repository"
    return
  end

  set_color -o $EL_WHITE
  echo -n ' at '

  set_color -o $EL_GREEN
  set -l branch (git symbolic-ref --short HEAD ^/dev/null; or git show-ref --head -s --abbrev | head -n1 ^/dev/null)
  echo -n "$branch"

  fish_prompt_git_state
end

function fish_prompt_git_state
  git diff-index --quiet --ignore-submodules --cached HEAD ^/dev/null; or set -l has_staged_files

  if set -q has_staged_files
    set_color -o $EL_GREEN
    echo -n " ✗"
    return
  end

  git diff-files --quiet --ignore-submodules ^/dev/null; or set -l has_unstaged_files

  if set -q has_unstaged_files
    set_color -o $EL_RED
    echo -n " ✗"
  end
end
