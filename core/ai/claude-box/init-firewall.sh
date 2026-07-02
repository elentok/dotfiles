#!/usr/bin/env bash
# Egress firewall: default-deny with a provider-aware allowlist.
#
# assemble_allowlist() is pure (no iptables/network calls) so it can be unit
# tested with bats. apply_firewall() does the actual iptables work and needs
# NET_ADMIN/NET_RAW + root.
set -euo pipefail

base_allowlist_subscription() {
	cat <<'EOF'
api.anthropic.com
console.anthropic.com
statsig.anthropic.com
sentry.io
registry.npmjs.org
github.com
api.github.com
raw.githubusercontent.com
objects.githubusercontent.com
codeload.github.com
pypi.org
files.pythonhosted.org
proxy.golang.org
sum.golang.org
EOF
}

base_allowlist_bedrock() {
	local region="${AWS_REGION:-us-east-1}"
	cat <<EOF
bedrock.${region}.amazonaws.com
bedrock-runtime.${region}.amazonaws.com
sts.amazonaws.com
EOF
	cat <<'EOF'
registry.npmjs.org
github.com
api.github.com
raw.githubusercontent.com
objects.githubusercontent.com
codeload.github.com
pypi.org
files.pythonhosted.org
proxy.golang.org
sum.golang.org
EOF
}

# assemble_allowlist <provider> - print one domain per line: the provider's
# base list plus any comma-separated EXTRA_ALLOWED_DOMAINS.
assemble_allowlist() {
	local provider="${1:-subscription}"

	case "$provider" in
	bedrock)
		base_allowlist_bedrock
		;;
	subscription | *)
		base_allowlist_subscription
		;;
	esac

	if [[ -n "${EXTRA_ALLOWED_DOMAINS:-}" ]]; then
		local domain
		IFS=',' read -ra extra_domains <<<"$EXTRA_ALLOWED_DOMAINS"
		for domain in "${extra_domains[@]}"; do
			domain="${domain// /}"
			[[ -n "$domain" ]] && printf '%s\n' "$domain"
		done
	fi
}

apply_firewall() {
	local provider="${CLAUDE_BOX_PROVIDER:-subscription}"
	local allowed_domains=()
	mapfile -t allowed_domains < <(assemble_allowlist "$provider")

	iptables -F
	iptables -X
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT DROP

	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# DNS must resolve before we can filter by resolved IP.
	iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

	local domain ip
	for domain in "${allowed_domains[@]}"; do
		for ip in $(dig +short "$domain" A); do
			[[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || continue
			iptables -A OUTPUT -d "$ip" -p tcp --dport 443 -j ACCEPT
		done
	done
}

# Only run the iptables side when executed directly; bats sources this file
# to exercise assemble_allowlist without root or network access.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	apply_firewall
fi
