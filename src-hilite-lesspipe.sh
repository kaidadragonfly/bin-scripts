#!/bin/bash

if [ -x "$(which source-highlight)" ]; then
    for source in "$@"; do
        case $source in
            *ChangeLog|*changelog)
                source-highlight --failsafe -f esc --lang-def=changelog.lang \
                    --style-file=esc.style -i "$source" ;;
            *Makefile|*makefile)
                source-highlight --failsafe -f esc --lang-def=makefile.lang \
                    --style-file=esc.style -i "$source" ;;
            '-')
                source-highlight --failsafe -f esc --lang-def=makefile.lang \
                    --style-file=esc.style -i /dev/stdin ;;
            *) source-highlight --failsafe --infer-lang -f esc \
                --style-file=esc.style -i "$source" ;;
        esac
    done
fi
