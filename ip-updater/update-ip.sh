#!/bin/bash
set -e

dynv6="/dynv6.sh"
cf="/cf.sh"

date
#ip4="$(curl -4 https://am.i.mullvad.net)"
ip4="10.13.2.10"
echo "ipv4 is $ip4"

# Ensure yq is installed
if ! command -v yq &>/dev/null; then
  echo "yq could not be found, please install yq first"
  exit
fi

# Read dynv6.records and dynv6.zones
dynv6_records=$(yq '.dynv6.records[]' "$CONFIG_FILE")
dynv6_zones=$(yq '.dynv6.zones[]' "$CONFIG_FILE")

for record in $dynv6_records; do
  record=${record//\"/}
  if dig +short @1.1.1.1 "$record" | grep -iq "$ip4"; then
    echo "Not updating IPv4 for $record"
  else
    $dynv6 records update "$record" A "$ip4"
    echo "Updated IPv4 for $record"
  fi
done

for zone in $dynv6_zones; do
  zone=${zone//\"/}

  if dig +short @1.1.1.1 "$zone" | grep -iq "$ip4"; then
    echo "Not updating IPv4 for $zone"
  else
    $dynv6 hosts "$zone" set ipv4addr "$ip4"
    echo "Updated IPv4 for $zone"
  fi
done

# Loop over cf.zones and their records
cf_zones=$(yq '.cf.zones[].name' "$CONFIG_FILE")

for cf_zone in $cf_zones; do
  cf_zone=${cf_zone//\"/}
  echo "Zone: $cf_zone"
  cf_records=$(yq ".cf.zones[] | select(.name == \"$cf_zone\") | .records[]" "$CONFIG_FILE")

  cf_record_str=""
  for record in $cf_records; do
    record=${record//\"/}
    echo "Test    $record        $cf_zone"
    if dig +short @1.1.1.1 "$record.$cf_zone" | grep -iq "$ip4"; then
      echo "Not updating record $record.$cf_zone"
    else
      cf_record_str+="-r $record.$cf_zone "
    fi
  done
  echo "cf record string: $cf_record_str"
  if [[ "" != "$cf_record_str" ]]; then
    # shellcheck disable=SC2086
    $cf -4 "$ip4" --key "$CF_KEY" --zone "$cf_zone" $cf_record_str
    echo "Updated IPv4 for $cf_zone"
  else
    echo "Not updating IPv4 for $cf_zone"
  fi

done
