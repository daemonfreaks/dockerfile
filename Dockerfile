FROM ubuntu:latest

LABEL maintainer="daemonfreaks"


# Install and locales.
RUN apt update -y && apt install -y locales && rm -rf /var/lib/apt/lists/* && locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8


# Install basic tools
RUN apt update -y && apt install -y man curl && rm -rf /var/lib/apt/lists/*


# Install SHELL zsh
RUN apt update -y && apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions && rm -rf /var/lib/apt/lists/*
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]


# Install PAGER
ARG OV_VERSION=0.53.0
RUN curl -L -O https://github.com/noborus/ov/releases/download/v${OV_VERSION}/ov_${OV_VERSION}_amd64.deb \
    && dpkg -i ov_${OV_VERSION}_amd64.deb
ENV PAGER=/usr/bin/ov


# Install EDITOR
RUN apt update -y && apt install -y vim && rm -rf /var/lib/apt/lists/*
ENV EDITOR=/usr/bin/vim


# Install GitHub CLI
RUN (type -p wget >/dev/null || (apt update -y && apt install -y wget)) \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && mkdir -p -m 755 /etc/apt/sources.list.d \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update -y \
    && apt install gh -y


# Install coding agents
RUN curl -fsSL https://gh.io/copilot-install | bash
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -fsSL https://chatgpt.com/codex/install.sh | sh
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash
