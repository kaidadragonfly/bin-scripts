#!/bin/sh

IPV4=$(curl --silent --fail-early https://v4.rojoma.com/ip/)
IPV6=$(curl --silent --fail-early https://v6.rojoma.com/ip/)

set -e

if [ "$IPV4" ]; then
    curl -X PUT "https://api.gandi.net/v5/livedns/domains/$GANDI_DOMAIN/records/@/A" \
         -H "content-type: application/json" \
         -H "authorization: Apikey ${GANDI_API_KEY}" \
         -d "{\"rrset_values\": [ \"$IPV4\" ], \"rrset_ttl\": 300}"
fi

if [ "$IPV6" ]; then
    curl -X PUT "https://api.gandi.net/v5/livedns/domains/$GANDI_DOMAIN/records/@/AAAA" \
         -H "content-type: application/json" \
         -H "authorization: Apikey ${GANDI_API_KEY}" \
         -d "{\"rrset_values\": [ \"$IPV6\" ], \"rrset_ttl\": 300}"
fi
