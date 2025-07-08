blue="\[\e[34m\]"
# green="\[\e[32m\]"
yellow="\\033[33m"
reset="\[\e[m\]"

workdir="$blue\w$reset"

export PS1="\n${yellow}[BASH] \u at \h (\t)   \$(fnm current)$reset
$workdir$reset
› "
