#!/bin/bash

#
# Install Eclipse Java EE Plugins
#

# $1 is the repository it is at
# $2 is plugin classname to install

REPOSITORY="$1"
CLASSNAME="$2"

if find_executable "eclipse" "eclipse"; then
    ECLIPSE="$EXECUTABLE"
    set +e
    while true; do
        echo "> Running Eclipse installation of $CLASSNAME from $REPOSITORY"
        if "$ECLIPSE" -nosplash -application org.eclipse.equinox.p2.director -repository "$REPOSITORY" -installIU "$CLASSNAME"; then
            set -e
            break
        elif ! prompt "> Failed to install Eclipse plugin, try again"; then
            exit 1
        fi
    done
else
    echo "> Couldn't find an installation of Eclipse to install plugins into"
    exit 1
fi
