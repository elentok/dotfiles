export SSH_AUTH_SOCK="$HOME/.ssh/active-agent"

alias dotfi 'cd $DOTF'
alias dotl 'cd $DOTL'
alias f 'vifm'
alias g 'git'
alias gp 'cd (list-projects | fzf | sed "s#~#$HOME#")'
alias se 'sudoedit'
alias ts 'tig status'
alias v 'nvim'
alias vi 'nvim'
alias psg='ps -a -x -o user,pid,command | grep'

function tm
  if test -z "DISPLAY"
    set DISPLAY ':0'
  end
  tmux -u $argv
end

function ff
  if count $argv > /dev/null
    rg --files --iglob "*$argv*"
  else
    rg --files
  end
end

function f
  if count $argv > /dev/null
    vifm $argv
  else
    vifm .
  end
end

function fish_user_key_bindings
  # make ctrl-c clear the command line (to prevent breaking the prompt)
  bind \cc 'commandline ""'
end

if test -e "$DOTL/config.fish"
  source "$DOTL/config.fish"
end
