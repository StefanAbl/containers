#!/bin/sh
set -eu

# Generic entrypoint: everything under CRON_CONFIG_DIR is supplied via a
# mounted ConfigMap.
#
#   - a file named "crontab"  -> installed as the root crontab
#   - any other file          -> copied into SCRIPTS_DIR and made
#                                 executable, so the crontab can call it
#
# ConfigMap volume mounts are read-only and not executable, which is why
# everything is copied into writable locations before crond starts.

CRON_CONFIG_DIR="${CRON_CONFIG_DIR:-/etc/cron-config}"
SCRIPTS_DIR="${SCRIPTS_DIR:-/scripts}"
TARGET_CRONTAB="/etc/crontabs/root"

mkdir -p "${SCRIPTS_DIR}"

if [ -d "${CRON_CONFIG_DIR}" ]; then
  for f in "${CRON_CONFIG_DIR}"/*; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    if [ "$name" = "crontab" ]; then
      cp "$f" "${TARGET_CRONTAB}"
      chmod 0600 "${TARGET_CRONTAB}"
    else
      cp "$f" "${SCRIPTS_DIR}/${name}"
      chmod +x "${SCRIPTS_DIR}/${name}"
    fi
  done
fi

echo "entrypoint: installed crontab:"
cat "${TARGET_CRONTAB}"
echo "entrypoint: scripts in ${SCRIPTS_DIR}:"
ls -l "${SCRIPTS_DIR}" || true

# Run crond as a child process rather than `exec`-ing into it. If crond
# becomes PID 1 it's also the session leader, and its startup setpgid()
# call then fails with "setpgid: Operation not permitted" (EPERM - you
# can't change a session leader's process group). Keeping this script as
# PID 1 avoids that; the trap forwards termination signals to crond so
# `kubectl delete` / rolling updates still stop it promptly.
trap 'kill -TERM "$child" 2>/dev/null' TERM INT

crond -f -l 8 &
child=$!
wait "$child"
