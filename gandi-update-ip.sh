#!/bin/sh

IPV4=$(curl --silent --fail-early https://v4.rojoma.com/ip/)
IPV6=$(curl --silent --fail-early https://v6.rojoma.com/ip/)

set -e

curl -D- -XPUT -H "Content-Type: text/plain" \
    -H"X-Api-Key: ${GANDI_API_KEY}" \
    --data-binary @- \
    "https://dns.api.gandi.net/api/v5/zones/${GANDI_ZONE_UUID}/records" \
    << EOF
@ IN A $IPV4
@ IN AAAA $IPV6
@ IN MX 10 mail.protonmail.ch.
@ IN MX 20 mailsec.protonmail.ch.
@ IN TXT v=spf1 include:_spf.protonmail.ch mx ~all
@ IN TXT protonmail-verification=f79fb7a7dc0a994b9a81efb1bfef25b033d80887
protonmail._domainkey IN CNAME protonmail.domainkey.d6f53phdnq5rcyahxvtjo4erl6zcn2ycbfwaskhb6mvy4yoftglea.domains.proton.ch.
protonmail2._domainkey IN CNAME protonmail2.domainkey.d6f53phdnq5rcyahxvtjo4erl6zcn2ycbfwaskhb6mvy4yoftglea.domains.proton.ch.
protonmail3._domainkey IN CNAME protonmail3.domainkey.d6f53phdnq5rcyahxvtjo4erl6zcn2ycbfwaskhb6mvy4yoftglea.domains.proton.ch.
EOF
