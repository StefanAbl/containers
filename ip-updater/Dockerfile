FROM ubuntu:24.04
RUN apt update && \
 apt install -y curl dnsutils jq yq && \
 rm -rf /var/lib/apt/lists/*

COPY *.sh /
RUN chmod +x /dynv6.sh /cf.sh

RUN id -u 1000 &>/dev/null || useradd -m -u 1000 u1 -s /bin/sh

ENTRYPOINT ["/bin/bash", "/update-ip.sh"]
