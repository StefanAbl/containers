# cron

A generic, application-agnostic dcron runner. The image itself contains no
crontab and no scripts - everything it runs is supplied at runtime via a
ConfigMap mounted at `/etc/cron-config`.

## How it works

`entrypoint.sh` looks at every file under `/etc/cron-config`:

- a file named `crontab` is installed as `/etc/crontabs/root`
  (the standard "VAR=value" lines + schedule format; any `VAR=value`
  lines are exported into the environment of jobs crond runs)
- every other file is copied into `/scripts/` and made executable, so the
  crontab can call it (e.g. `/scripts/retention-cleanup.sh`)

ConfigMap volume mounts are read-only and not executable, which is why
files are copied into writable locations before `crond` starts.
