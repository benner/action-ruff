FROM alpine:3.22

ENV REVIEWDOG_VERSION=v0.21.0
ENV RUFF_VERSION=v0.13.2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/df70ed74df59de7ebfd9276afabd62ea2de4d7dd/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN wget -qO- https://astral.sh/uv/install.sh | sh
RUN /root/.local/bin/uv tool install ruff@${RUFF_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
