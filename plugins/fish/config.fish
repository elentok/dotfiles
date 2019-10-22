alias dotfi 'cd $DOTF'
alias dotl 'cd $DOTL'
alias f 'vifm'
alias g 'git'
alias gp 'cd (list-projects | fzf | sed "s#~#$HOME#")'
alias se 'sudoedit'
alias ts 'tig status'
alias v 'nvim'
alias vi 'nvim'

function tm
  if test -z "DISPLAY"
    set DISPLAY ':0'
  end
  tmux -u $argv
end

function fish_user_key_bindings
  # make ctrl-c clear the command line (to prevent breaking the prompt)
  bind \cc 'commandline ""'
end

if test -e "$DOTL/config.fish"
  source "$DOTL/config.fish"
end
