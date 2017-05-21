# Elentok Zsh Prompt

# Setup {{{1

# Subject the prompt string through parameter expansion, command substitution
# and arithmetic expansion:
setopt PROMPT_SUBST

# Random animals {{{1

# Credit to https://github.com/aviaron
function random_animal {
  FIRST_ANIMAL=128045
  ICONS_COUNT=17
  UTF_CODE=$(( $RANDOM % $ICONS_COUNT + $FIRST_ANIMAL ))
  EMOJI="\U`printf '%x\n' $UTF_CODE`"
  echo -n $EMOJI
}

# Only support on Mac and outside of neovim
if [ "$(uname -s)" = "Darwin" -a -z "$NVIM_LISTEN_ADDRESS" ]; then
  random_animal="$(random_animal)  "
fi

# Exit code {{{1
success="%F{green}❯%f"
error="%F{red}❯%f"
exit_code="%(?.$success.$error) "

# Directory {{{1
directory="%F{blue}%~%f"

# User and host {{{1
user_and_host="%{\$fg_bold[black]%}$USERNAME at $(hostname)%f"

# Time {{{1
if [ "$ZSH_VERSION" = "5.0.5" ]; then
  time="%D{%H:%M:%S}"
else
  time="%D{%H:%M:%S.%.}"
fi
time="%{\$fg_bold[black]%}($time)%f"

# Git {{{1

# required zsh modules
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz colors && colors

# refresh the git status before every command
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true # required to show staged/unstaged
zstyle ':vcs_info:*' use-simple true # faster, but less accurate
zstyle ':vcs_info:*' stagedstr ' %F{green}✗%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}✗%f'
zstyle ':vcs_info:*' formats ' at %F{green}%b%f%u%c'
zstyle ':vcs_info:*' actionformats ' at %F{green}%b%f%u%c (%a)'

# To disable the source control part of the prompt (in case of slow downs) use
# the following command:
#
# zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/.zsh(|/*)"

git_status='${vcs_info_msg_0_}'

# Full prompt {{{1

PROMPT="
$user_and_host $time
$directory$git_status
$random_animal$exit_code"

# vim: filetype=zsh foldmethod=marker
