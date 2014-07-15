#!/bin/bash

#
# Awesome window manager
#

if install "awesome awesome-extra" "AwesomeWM"; then
    bash ./setup_awesome.sh
    install "xfce4-power-manager"
    if [ -e /usr/share/awesome/lib/rodentbane.lua ]; then
        if prompt "> Download and install rodentbane?"; then
            if git_clone_and_submodule_init_update "git://git.glacicle.com/awesome/rodentbane.git"; then
                while true; do
                    if [ -e rodentbane/rodentbane.lua ]; then
                        print "Installing rodentbane.lua to awesome lib folder"
                        if sudo cp rodentbane/rodentbane.lua /usr/share/awesome/lib/; then
                            break
                        else
                            if ! prompt ">> Failed to install rodentbane.lua, try again"; then
                                break
                            fi
                        fi
                    else
                        print "Cannot locate rodentbane/rodentbane.lua"
                    fi
                done
            fi
        fi
    fi
    install "xdotool" "Required automation tool for rodentbane"
fi
