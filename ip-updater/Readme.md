# IP Updater


Define the following variables

- `CF_TOKEN` API token for cloudflare
- `DYNV6_TOKEN` API token for dynv6.com
- `CONFIG_FILE` path to a file of the following format:


```
dynv6:
    records: # List of records of zones in dynv6
      - something.centostest.v6.rocks
    zones: #List of dynv6 zones
      - centostest.v6.rocks
cf:
    zones:
    - name: example.com
      records:
      - "@"
      - "www"
```
