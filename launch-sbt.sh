#!/bin/bash

cd "$(proj-root)" || exit

if [ -e "$(proj-root)/.sbt-opts" ]; then
    source "$(proj-root)/.sbt-opts"
else
    SBT_OPTS=(-Xmx512M ${SBT_OPTS})
fi
export SBT_OPTS

export PATH="${JAVA_HOME}/bin:${PATH}"
exec java "${SBT_OPTS[@]}" -jar "${SBT_LAUNCH_JAR}" "$@"
