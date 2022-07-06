# https://hub.docker.com/_/alpine
FROM alpine:3.16@sha256:4ff3ca91275773af45cb4b0834e12b7eb47d1c18f770a0b151381cd227f4c253

RUN set -euxo pipefail && \
    adduser -S -D -H --gecos "" -s /bin/sh nmap && \
    apk add --no-cache tini libcap nmap && \
    setcap cap_net_raw,cap_net_bind_service+eip $(which nmap)

USER nmap

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/nmap", "--privileged"]
