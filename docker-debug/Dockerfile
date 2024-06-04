FROM debian:latest
ARG userId=10000

USER root

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  dnsutils \
  findutils \
  gnupg \
  htop \
  jq \
  netcat-openbsd \
  procps \
  sudo \
  tcpdump \
  telnet \
  unzip \
  vim \
  wget \
  zip

RUN curl -o websocat https://github.com/vi/websocat/releases/download/v1.12.0/websocat.x86_64-unknown-linux-musl \
    && install --owner="$userId" --target-directory=/usr/local/bin ./websocat

COPY ./sudoers /etc/sudoers

RUN adduser debugger --uid "$userId" && usermod -aG sudo debugger

USER $userId
