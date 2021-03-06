# vim: foldmethod=marker

# Prompt {{{1
success="%F{green}❯%f"
error="%F{red}❯%f"
exit_code="%(?.$success.$error) "

directory="%F{blue}%~%f"

export PROMPT="
%F{red}$(whoami) at $(hostname)%f
$directory
$exit_code"

# Aliases {{{1
alias ls='command ls --color=always -XFhs'
alias g='git'
