FROM alpine

RUN apk add --update --no-cache postfix=3.8.6-r0 postfix-ldap=3.8.6-r0 ca-certificates tzdata

COPY run.sh /

RUN chmod +x /run.sh

USER root

CMD ["/bin/sh", "-c", "/run.sh"]
