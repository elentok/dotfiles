# Elentok Zsh Prompt

# Setup {{{1

# Subject the prompt string through parameter expansion, command substitution
# and arithmetic expansion:
setopt PROMPT_SUBST

# Execution time {{{1
#
# Here's the basic order of events when a command is executed in Zsh:
#
# 1. The preexec hook (if defined) is called before the command is executed.
# 2. The command is executed.
# 3. The precmd hook (if defined) is called just before the prompt is displayed.

# Runs before the command is executed
function preexec() {
  DOTF_CMD_START_TIME=$SECONDS
}

# Runs after the command is executed
function precmd() {
  _last_cmd_runtime=''
  if [ -n "${DOTF_CMD_START_TIME:-}" ]; then
    local runtime=$(($SECONDS - $DOTF_CMD_START_TIME))
    _last_cmd_runtime=$(dotf-format-seconds ${runtime})
  fi
}

function dotf-format-seconds() {
  local seconds="$1"
  if [[ "$seconds" -lt 1 ]]; then
    millisec=$((seconds * 1000))
    dotf-format-number $millisec ms
  elif [[ "$seconds" -ge 3600 ]]; then
    hours=$((seconds / 3600.0))
    dotf-format-number $hours hr
  elif [[ "$seconds" -ge 60 ]]; then
    minutes=$((seconds / 60.0))
    dotf-format-number $minutes m
  else
    dotf-format-number $seconds s
  fi
}

function dotf-format-number() {
  local number="$1"
  local unit="$2"
  number=$(printf '%.2f' ${number})
  number="${number/%.00/}"
  echo -n "${number}${unit}"
}

# Exit code {{{1
# prefix_char=''
prefix_char=''
# prefix_char='󰌕'
success="%F{green}${prefix_char}%f"
error="%F{red}${prefix_char}%f"
exit_code="%(?.$success.$error) "

function dotf-half-bubble() {
  local fg="$1"
  local bg="$2"
  local text="$3"
  echo -ne "%K{$bg}%F{$fg}$text%f%k"
  echo -ne "%F{$bg}%f"
}

function bubble() {
  local fg="$1"
  local bg="$2"
  local text="$3"
  echo -ne "%F{$bg}%f"
  echo -ne "%K{$bg}%F{$fg}$text%f%k"
  echo -ne "%F{$bg}%f"
}

# Line 1 (user, host and last runtime) {{{1
_prompt_user_and_host="$(bubble gray black " $USERNAME@${SHORT_HOST}")"
_prompt_cmd_runtime="$(bubble gray black ' ${_last_cmd_runtime}')"
_prompt_line1="${_prompt_user_and_host} ${_prompt_cmd_runtime}"

# Line 2 (Directory) {{{1
# directory="%F{blue}%f%K{blue}%F{black}%~%k%F{blue}%f"
directory="$(bubble black blue '%~')"
# directory="%K{blue} %F{black}%~%k%F{blue}%f"
# Time {{{1
if [ "$ZSH_VERSION" = "5.0.5" ]; then
  time="%D{%H:%M:%S}"
else
  time="%D{%H:%M:%S.%.}"
fi
# time="%{\$fg_bold[cyan]%}($time)%f"
time="%F{black}($time)%f"

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
PROMPT="$directory$git_status
$exit_code"

if [ ! -e ~/.miniprompt ]; then
  PROMPT="$_prompt_line1
$PROMPT"
fi

PROMPT="
$PROMPT"

# vim: filetype=zsh foldmethod=marker
