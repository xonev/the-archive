FROM debian:latest
ARG userId=10000

USER root

RUN apt-get update && apt-get install -y \
  curl \
  dnsutils \
  findutils \
  gnupg \
  htop \
  jq \
  netcat-openbsd \
  procps \
  sudo \
  telnet \
  unzip \
  vim \
  wget \
  zip

COPY ./sudoers /etc/sudoers

RUN adduser debugger --uid "$userId" && usermod -aG sudo debugger
USER $userId
