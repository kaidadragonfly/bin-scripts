#!/bin/sh

set -e

IPV4=$(curl --silent --fail-early https://v4.rojoma.com/ip/)
IPV6=$(curl --silent --fail-early https://v6.rojoma.com/ip/)

curl -D- -XPUT -H "Content-Type: text/plain" \
    -H"X-Api-Key: ${GANDI_API_KEY}" \
    --data-binary @- \
    "https://dns.api.gandi.net/api/v5/zones/${GANDI_ZONE_UUID}/records" \
    << EOF
@ IN A $IPV4
@ IN AAAA $IPV6
@ IN TXT $EMAIL_RECORD
EOF
