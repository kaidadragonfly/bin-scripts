#!/usr/bin/env bash

# Based on the script
# from here: https://blakerain.com/blog/adding-dns-adblock-to-unbound/

# NOTE: You should run as the unbound user and
# need to make sure that UNBOUND_DIR is writable by the user.

UNBOUND_DIR="/etc/unbound/local.d/"
UNBOUND_EXCEPTIONS_FILE="$UNBOUND_DIR/adblock.exceptions"
URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

if ! [ -f "$UNBOUND_EXCEPTIONS_FILE" ]; then
    touch "$UNBOUND_EXCEPTIONS_FILE"
fi

/usr/bin/wget -qO- "$URL" | /usr/bin/grep '^0\.0\.0\.0' | /usr/bin/sort | \
  /usr/bin/awk '{print "local-zone: \""$2"\" refuse"}' > "$UNBOUND_DIR/adblock.conf"
(/usr/bin/cat "$UNBOUND_EXCEPTIONS_FILE" | \
  /usr/bin/awk '{gsub(/\./,"\\."); print "g/\"" $0 "\"/d"}'; echo w) | /usr/bin/ed - "$UNBOUND_DIR/adblock.conf"
/usr/bin/cat "$UNBOUND_EXCEPTIONS_FILE" | \
  /usr/bin/awk '{print "local-zone: \""$0".\" transparent"}' > "$UNBOUND_DIR/adblock.exceptions.conf"
