#!/usr/bin/env bash

UNBOUND="/var/unbound/etc/"
URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
wget -qO- "$URL" | grep '^0\.0\.0\.0' | sort | \
  awk '{print "local-zone: \""$2"\" refuse"}' > "$UNBOUND/adblock.conf"
(cat "$HOME/adblock.exceptions" | \
  awk '{gsub(/\./,"\\."); print "g/\"" $0 "\"/d"}'; echo w) | ed - "$UNBOUND/adblock.conf"
cat "$HOME/adblock.exceptions" | \
  awk '{print "local-zone: \""$0".\" transparent"}' > "$UNBOUND/adblock.exceptions.conf"
