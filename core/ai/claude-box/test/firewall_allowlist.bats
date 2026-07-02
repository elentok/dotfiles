#!/usr/bin/env bats

setup() {
  # apply_firewall must not run just from sourcing (no root/iptables in CI).
  source "${BATS_TEST_DIRNAME}/../init-firewall.sh"
}

@test "defaults to the subscription allowlist when no provider given" {
  run assemble_allowlist
  [ "$status" -eq 0 ]
  [[ "$output" == *"api.anthropic.com"* ]]
}

@test "subscription provider includes the Anthropic API host" {
  run assemble_allowlist subscription
  [ "$status" -eq 0 ]
  [[ "$output" == *"api.anthropic.com"* ]]
  [[ "$output" == *"github.com"* ]]
}

@test "bedrock provider includes bedrock hosts and excludes the Anthropic API host" {
  run assemble_allowlist bedrock
  [ "$status" -eq 0 ]
  [[ "$output" == *"bedrock-runtime.us-east-1.amazonaws.com"* ]]
  [[ "$output" != *"api.anthropic.com"* ]]
}

@test "bedrock provider honors AWS_REGION" {
  export AWS_REGION="eu-west-1"
  run assemble_allowlist bedrock
  unset AWS_REGION
  [[ "$output" == *"bedrock-runtime.eu-west-1.amazonaws.com"* ]]
}

@test "an unknown provider falls back to the subscription allowlist" {
  run assemble_allowlist some-unknown-provider
  [[ "$output" == *"api.anthropic.com"* ]]
}

@test "EXTRA_ALLOWED_DOMAINS appends extra domains" {
  export EXTRA_ALLOWED_DOMAINS="extra.example.com,another.example.com"
  run assemble_allowlist subscription
  unset EXTRA_ALLOWED_DOMAINS
  [[ "$output" == *"extra.example.com"* ]]
  [[ "$output" == *"another.example.com"* ]]
}

@test "EXTRA_ALLOWED_DOMAINS strips spaces and ignores empty entries" {
  export EXTRA_ALLOWED_DOMAINS=" extra.example.com ,, another.example.com"
  run assemble_allowlist subscription
  unset EXTRA_ALLOWED_DOMAINS
  [[ "$output" == *"extra.example.com"* ]]
  [[ "$output" == *"another.example.com"* ]]
  [[ "$output" != *$'\n\n'* ]]
}

@test "no EXTRA_ALLOWED_DOMAINS does not add blank lines" {
  unset EXTRA_ALLOWED_DOMAINS || true
  run assemble_allowlist subscription
  [[ "$output" != *$'\n\n'* ]]
}
