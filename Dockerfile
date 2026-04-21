# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=node:22-slim
FROM ${BASE_IMAGE}

ARG CLAUDE_CODE_VERSION=latest
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg \
  && install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg \
       -o /etc/apt/keyrings/docker.asc \
  && chmod a+r /etc/apt/keyrings/docker.asc \
  && . /etc/os-release \
  && echo "deb [arch=${TARGETARCH} signed-by=/etc/apt/keyrings/docker.asc] \
       https://download.docker.com/linux/debian $VERSION_CODENAME stable" \
       > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y --no-install-recommends \
       docker-ce-cli \
       docker-buildx-plugin \
       docker-compose-plugin \
       git \
       less \
       jq \
       procps \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

WORKDIR /workspace
CMD ["bash"]
