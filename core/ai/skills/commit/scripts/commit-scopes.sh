#!/usr/bin/env bash

set -euo pipefail

count="${1:-250}"

parsed="$(
  git log -n "$count" --pretty=%s | awk '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    {
      n = split($0, p, ": ")
      for (i = 1; i <= n; i++) p[i] = trim(p[i])

      # {scope}: {title}
      if (n == 2) {
        if (p[1] != "") print "S\t" p[1]
        next
      }

      # {jira-ticket}: {type}: {scope}: {sub-scope}: {title}
      if (n >= 5 && p[1] ~ /^[A-Z][A-Z0-9]*-[0-9]+$/) {
        if (p[3] != "") print "S\t" p[3]
        next
      }

      # {type}: {scope}: {sub-scope}: {title}
      if (n >= 4) {
        if (p[2] != "") print "S\t" p[2]
        next
      }

      # {type}: {scope}: {title}
      if (n >= 3) {
        if (p[2] != "") print "S\t" p[2]
      }
    }
  '
)"
scopes="$(
  printf "%s\n" "$parsed" |
    awk -F'\t' '$1 == "S" {print $2}' |
    sort -u
)"

if [[ -n "${scopes}" ]]; then
  printf "%s\n" "$scopes"
fi
