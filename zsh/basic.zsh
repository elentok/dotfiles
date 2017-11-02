# vim: foldmethod=marker

# Prompt {{{1
success="%F{green}❯%f"
error="%F{red}❯%f"
exit_code="%(?.$success.$error) "

directory="%F{blue}%~%f"

export PROMPT="
%F{red}$(whoami) at $(hostname)%f
$directory
o vim: foldmethod=marker

# Prompt {{{1
success="%F{green}❯%f"
error="%F{red}❯%f"
exit_code="%(?.$success.$error) "

directory="%F{blue}%~%f"

export PROMPT="
%F{blue}__________________________________%f
%F{red}$(whoami) at $(hostname)%f
$directory
$exit_code"
$exit_code"
