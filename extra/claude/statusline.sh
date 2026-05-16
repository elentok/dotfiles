#!/usr/bin/env bash

# Claude Code status line script
# Displays token usage, context window percentage, and rate limit percentages.
# Input: JSON object from Claude Code via stdin

input=$(cat)

tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

BLACK="\\033[30m"
GRAY="\x1b[38;5;241m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
PURPLE="\\033[35m"
CYAN="\\033[36m"
UNDERLINE="\\033[4m"
RESET="\\033[0m"

percent_ctx="$(printf '%.0f' "$ctx")%"
percent_five="$(printf '%.0f' "$five")%"
percent_week="$(printf '%.0f' "$week")%"

echo "${CYAN}$model${RESET}" \
  "${YELLOW}used $tok tokens${RESET}" \
  "(${PURPLE}$percent_ctx of total,${RESET}" \
  "$percent_five of 5h," \
  "$percent_week of weekly)"
