# Generic dcron-based cron runner.
#
# Nothing application-specific lives in this image - the crontab and any
# scripts it runs are supplied entirely at runtime via a ConfigMap mounted
# at /etc/cron-config (see entrypoint.sh). This image only needs rebuilding
# if the cron-runner mechanics themselves change.

FROM alpine:3.24

RUN apk add --no-cache dcron

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
 && touch /etc/crontabs/root \
 && chmod 0600 /etc/crontabs/root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
