# claude-box: a lean, sandboxed image for running Claude Code with reduced or
# no permission prompts. Non-root user, egress firewall, isolated ~/.claude.
# See docs/prds/claude-box.md and docs/adr/0001-bypass-in-container-vs-auto-mode.md.
FROM debian:bookworm-slim

ARG NODE_MAJOR=24
ARG GO_VERSION=1.26.4
ARG GOSU_VERSION=1.17
ARG CLAUDE_CODE_VERSION=latest

ENV DEBIAN_FRONTEND=noninteractive \
    DISABLE_AUTOUPDATER=1 \
    LANG=C.UTF-8 \
    PATH="/usr/local/go/bin:/home/dev/go/bin:/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Base OS packages: build tools (needed by Homebrew), runtimes' dependencies,
# CLI tools, and firewall tooling (iptables/dig).
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    dnsutils \
    git \
    iproute2 \
    iptables \
    jq \
    fd-find \
    procps \
    python3 \
    python3-pip \
    ripgrep \
    sudo \
    xz-utils \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# gosu: drop privileges from root -> dev after the firewall is applied.
RUN arch="$(dpkg --print-architecture)" \
    && curl -fsSL -o /usr/local/bin/gosu \
       "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${arch}" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Go, installed system-wide and pinned.
RUN arch="$(dpkg --print-architecture)" \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${arch}.tar.gz" \
       -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# Node, pinned to a major version via NodeSource, for Claude Code.
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"

# Non-root user. Claude Code refuses --dangerously-skip-permissions as root.
RUN useradd --create-home --shell /bin/bash --uid 1000 dev \
    && echo "dev ALL=(root) NOPASSWD: /usr/sbin/iptables" >/etc/sudoers.d/dev-iptables \
    && chmod 0440 /etc/sudoers.d/dev-iptables

# Homebrew wants sudo to create its prefix if 'dev' doesn't already own it;
# pre-create and chown it so the non-interactive install below needs no sudo.
RUN mkdir -p /home/linuxbrew/.linuxbrew && chown -R dev:dev /home/linuxbrew

USER dev
WORKDIR /home/dev

# bd (beads) and rtk aren't packaged for apt; install via Homebrew (Linuxbrew),
# which Homebrew requires to run as a non-root user anyway.
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN brew install beads rtk

# Bake the skills symlink and CLAUDE.md pointer. core/ai is mounted read-only
# at runtime at $HOME/.dotfiles/core/ai, so these resolve once the container
# actually starts, not at build time.
RUN mkdir -p /home/dev/.claude \
    && ln -s /home/dev/.dotfiles/core/ai/skills /home/dev/.claude/skills \
    && printf '@~/.dotfiles/core/ai/AGENTS.md\n' >/home/dev/.claude/CLAUDE.md

USER root
COPY entrypoint.sh init-firewall.sh /usr/local/lib/claude-box/
RUN chmod 755 /usr/local/lib/claude-box/entrypoint.sh /usr/local/lib/claude-box/init-firewall.sh

ENTRYPOINT ["/usr/local/lib/claude-box/entrypoint.sh"]
CMD ["/bin/bash"]
