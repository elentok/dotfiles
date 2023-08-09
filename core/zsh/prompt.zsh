# Elentok Zsh Prompt

# Setup {{{1

# Subject the prompt string through parameter expansion, command substitution
# and arithmetic expansion:
setopt PROMPT_SUBST

# Helpers: Execution time {{{1
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
    _last_cmd_runtime="  $(dotf-format-seconds ${runtime})"
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

# Helpers: Git {{{1

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
zstyle ':vcs_info:*' formats ' %b%u%c'
zstyle ':vcs_info:*' actionformats ' %b%u%c (%a)'

# To disable the source control part of the prompt (in case of slow downs) use
# the following command:
#
# zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/.zsh(|/*)"

# Helpers: VI Mode {{{1

function zle-line-init {
  zle reset-prompt
}

function zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Helpers: Block {{{1

triangle="\uE0B0"

function _prompt_block() {
  local bg="$1"
  local fg="$2"
  local next_bg="$3"
  local text="$4"

  echo -ne "%K{$bg}%F{$fg}${text}%k%f"
  if [ -n "$next_bg" ]; then
    echo -ne "%K{$next_bg}"
  fi
  echo -ne "%F{$bg}${triangle}%f%k"
}

function _rprompt_block() {
  local prev_bg="$1"
  local bg="$2"
  local fg="$3"
  local text="$4"

  if [ -n "$prev_bg" ]; then
    echo -ne "%K{$prev_bg}"
  fi
  echo -ne "%F{$bg}%f%k"
  echo -ne "%K{$bg}%F{$fg}${text}%k%f"
}

# Helpers: Git {{{1

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
zstyle ':vcs_info:*' formats ' %b%u%c'
zstyle ':vcs_info:*' actionformats ' %b%u%c (%a)'

# To disable the source control part of the prompt (in case of slow downs) use
# the following command:
#
# zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/.zsh(|/*)"

# Prompt Line 1 {{{1
function _prompt_line1() {
  bg1=237
  fg1=white
  bg2=239
  fg2=white
  bg3=237
  fg3=white
  bg4=239
  fg4=white

  # _prompt_block $bg1 $fg1 $bg2 " ${USERNAME}@${SHORT_HOST} "
  _prompt_block $bg1 $fg1 $bg2 " %~ "
  _prompt_block $bg2 $fg2 '' '${vcs_info_msg_0_} ' # git status
  # _prompt_block $bg4 $fg4 '' '${_last_cmd_runtime} '
}

# Prompt Line 2 {{{1
# prefix_char=''
# prefix_char=''
# prefix_char=''
prefix_char=''
vi_mode='${${${KEYMAP:-main}/vicmd/}/main/ }'
success="%K{green}%F{black} ${vi_mode}%f%k%F{green}${prefix_char}%f"
error="%K{red}%F{black} ${vi_mode}%f%k%F{red}${prefix_char}%f"
exit_code="%(?.$success.$error) "
_prompt_line2="${exit_code}"

# Right Prompt {{{1
function _rprompt() {
  bg1=237
  fg1=white
  bg2=239
  fg2=white
  _rprompt_block '' $bg1 $fg1 '${_last_cmd_runtime} '
  _rprompt_block $bg1 $bg2 $fg2 " ${USERNAME}@${SHORT_HOST} "

}
RPROMPT="$(_rprompt)"

# Full prompt {{{1
PROMPT="
$(_prompt_line1)
$_prompt_line2"

# vim: filetype=zsh foldmethod=marker
