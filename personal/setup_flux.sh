#!/bin/bash

#
# Setup F.lux
# http://justgetflux.com/linux.html
#

echo "> Adding repo: ppa:kilian/f.lux"
echo ">> See http://justgetflux.com/linux.html"
while true; do
    if sudo add-apt-repository ppa:kilian/f.lux; then
        echo ">> Updating repos..."
        sudo apt-get update
        install "fluxgui" "F.lux (redshift is based off this)"
        break
    elif ! prompt "Try again"; then
        break
    fi
done
