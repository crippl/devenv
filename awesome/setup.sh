#!/bin/bash

#
# Awesome window manager
#

if install "awesome awesome-extra" "AwesomeWM"; then
    bash ./setup_awesome.sh
    install "xfce4-power-manager"
fi
