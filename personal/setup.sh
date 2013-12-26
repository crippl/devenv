#!/bin/bash

#
# Personal software
#

#set -x

DROPBOX_DIST_EXEC=`echo ~/.dropbox-dist/dropboxd`

install_dropbox() {
    # Install dropbox
    # Returns: success/failure

    echo "> Installing Dropbox"
    if [ ! `hash dropbox 2>/dev/null` ] && [ ! -e "$DROPBOX_DIST_EXEC" ]; then
        if prompt "> Install dropbox"; then
	    MACHINE_TYPE=`uname -m`
	    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
		# 64-bit stuff here
	        cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
                retval=$?
                cd -
                return $retval
	    else
		# 32-bit stuff here
	        cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf - 
                retval=$?
                cd -
                return $retval
	    fi
            return 0
        else
            echo "> Skipping....";
            return 0
        fi
    else
        echo ">> *Dropbox already installed"
    fi
}

start_dropbox() {
    # Starts Dropbox
    # Returns: success/failure
    echo "> Starting Dropbox"
    if ! isrunning dropbox; then
        if prompt "> Start Dropbox"; then
            if [ runnable dropbox ]; then
                dropbox start
            elif [ -e "$DROPBOX_DIST_EXEC" ]; then
                $DROPBOX_DIST_EXEC&
            fi
            return $?
        else
            echo "> Skipping....";
            return 1
        fi
    else
        echo ">> *Dropbox already running"
    fi
}

if install_dropbox; then
    start_dropbox
fi
install "nautilus-dropbox" "Dropbox nautilus support"

if install "anki mecab mplayer" "Anki"; then
    install "dvipng" "Anki Latex support"
fi
install "goldendict" "Goldendict" 
install "wine mesa-utils" "Wine"
install "ibus-mozc" "Google Japanese IME" 
if install "gtk-redshift" "Redshift"; then
    install "geoclue geoclue-hostip" "Geoclue"
    if [ -e "./setup_redshift.sh" ]; then
        bash ./setup_redshift.sh
    fi
fi
install "dia" "DIA"
install "jupiter" "Jupiter power daemon"
install "cpufrequtils" "cpufrequtils"
install "gimp" "The Gimp"
install "scrot" "scrot"
if available "skype"; then
    install "skype" "Skype"
else
    if prompt "> Download skype with a browser"; then
        URL=http://www.skype.com/en/download-skype/skype-for-computer/
        echo "> Loading $URL"
        firefox "$URL" 2>&1 > /dev/null&
    fi
fi
    
if install "awesome awesome-extra" "AwesomeWM"; then
    bash ./setup_awesome.sh
fi


