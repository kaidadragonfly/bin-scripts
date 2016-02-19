#!/bin/bash

if [ "$JAVA_HOME" ]; then
    SBT_OPTS=(-Xms512M -Xmx2048M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=1024M ${SBT_OPTS})
    export SBT_OPTS
else
    if [ -x /usr/libexec/java_home ]; then
        JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
        export JAVA_HOME
    fi
    
    if [ -e "$(proj-root)/.sbt-opts" ]; then
        # shellcheck source=/dev/null
        source "$(proj-root)/.sbt-opts" 
    else
        SBT_OPTS=(-Xmx512M ${SBT_OPTS})
    fi
    export SBT_OPTS
fi

export PATH="${JAVA_HOME}/bin:${PATH}"
exec java "${SBT_OPTS[@]}" -jar /usr/local/Library/LinkedKegs/sbt/libexec/sbt-launch.jar "$@"
