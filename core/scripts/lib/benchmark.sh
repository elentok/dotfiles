#!/usr/bin/env bash

if [[ "${BASH_VERSION:-}" =~ ^3.* ]]; then
  benchmark-start() {
    echo
  }

  benchmark-stop() {
    echo
  }
else
  declare -A BENCHMARKS=()

  benchmark-start() {
    key=${1:-GLOBAL}
    BENCHMARKS[$key]=$SECONDS
  }

  benchmark-stop() {
    key=${1:-GLOBAL}
    duration=$((SECONDS * 1000 - BENCHMARKS[$key] * 1000))
    if [[ $duration -gt 1000 ]]; then
      duration=$((duration / 1000))
      printf '%.2fs' $duration
    else
      printf '%.2fms' $duration
    fi
  }
fi
