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
# UI Helpers {{{1

function _prompt_right_bubble() {
  local fg="$1"
  local bg="${2:-}"
  if [ -z "$bg" ]; then
    echo -ne "%F{$fg}%f"
  else
    echo -ne "%K{$bg}%F{$fg}%f%k"
  fi
}

# Prompt Lines {{{1

function _prompt_line1() {
  color1=blue
  color2=cyan
  color3=blue
  # user & host
  echo -n "%K{$color1}%F{black}  $USERNAME@${SHORT_HOST}%k%f"
  _prompt_right_bubble $color1 $color2

  # git status
  echo -n "%K{$color2}%F{black}\${vcs_info_msg_0_}%k%f"
  _prompt_right_bubble $color2 $color3

  # runtime
  echo -n "%K{$color3}%F{black}  \${_last_cmd_runtime}%k%f"
  _prompt_right_bubble $color3
}

function _prompt_line2() {
  echo -n '%K{yellow}%F{black} %~%f%k'
  _prompt_right_bubble yellow
}

# prefix_char=''
# prefix_char=''
prefix_char=''
success="%K{green} %k%F{green}${prefix_char}%f"
error="%K{red} %k%F{red}${prefix_char}%f"
exit_code="%(?.$success.$error) "
_prompt_line3="${exit_code}"

# Git {{{1

# required zsh modules
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz colors && colors

# refresh the git status before every command
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true # required to show staged/unstaged
zstyle ':vcs_info:*' use-simple true        # faster, but less accurate
zstyle ':vcs_info:*' stagedstr ' %F{green}✗%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}✗%f'
zstyle ':vcs_info:*' formats ' at %b%u%c'
zstyle ':vcs_info:*' actionformats ' at %b%u%c (%a)'

# To disable the source control part of the prompt (in case of slow downs) use
# the following command:
#
# zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/.zsh(|/*)"

# Full prompt {{{1
PROMPT="$(_prompt_line2)
$_prompt_line3"

if [ ! -e ~/.miniprompt ]; then
  PROMPT="$(_prompt_line1)
$PROMPT"
fi

PROMPT="
$PROMPT"

echo PROMPT!

# vim: filetype=zsh foldmethod=marker
