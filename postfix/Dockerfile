FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y postfix postfix-ldap openssl sudo bash dnsutils vim telnet less inotify-tools && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives
RUN mkdir -p /config /data &&\
    addgroup --system --gid 1000 user &&\
    adduser --system --disabled-password --no-create-home \
      --ingroup user --firstuid 1000 --lastuid 1000 user

RUN echo "NETWORK_TIMEOUT 3" >> /etc/ldap/ldap.conf &&\
    echo "TIMEOUT 3" >> /etc/ldap/ldap.conf

SHELL ["/bin/bash", "-c"]
VOLUME ["/config", "/data"]
CMD postfix -c /config start-fg
