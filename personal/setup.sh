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
        echo "> Installed Already: Dropbox"
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
        echo "> Already Running: Dropbox"
    fi
}

install_rescuetime() {
    # Downloads rescuetime
    # Returns: success/failure

    echo "> Installing Rescuetime"
    if ! runnable rescuetime; then
        if prompt "> Install Rescuetime"; then
	    MACHINE_TYPE=`uname -m`
            if [ ! -e `echo ~/rescuetime.deb` ] || ! prompt "> ~/rescuetime.deb already exists, install that"; then
	        if [ ${MACHINE_TYPE} == 'x86_64' ]; then
		    # 64-bit stuff here
	            RESCUETIMEURL="https://www.rescuetime.com/installers/rescuetime_current_amd64.deb"
                    # https://www.rescuetime.com/installers/rescuetime_current_amd64.rpm
	        else
		    # 32-bit stuff here
                    RESCUETIMEURL="https://www.rescuetime.com/installers/rescuetime_current_i386.deb"
                    # https://www.rescuetime.com/installers/rescuetime_current_i386.rpm
	        fi
                if [ -n "$RESCUETIMEURL" ]; then
                    while true; do
                        if cd ~ && wget -O - "$RESCUETIMEURL" > rescuetime.deb; then
                            cd -
                            break;
                        else
                            if ! prompt "> Try downloading again"; then
                                break;
                            fi
                        fi
                    done
                fi
            fi
            if [ -e `echo ~/rescuetime.deb` ]; then
                while true; do
                    require_package "gtk2-engines-pixbuf"
                    if install_deb_file `echo ~/rescuetime.deb`; then
                        break;
                    else
                        if ! prompt "> Try installing again"; then
                            return 1
                            break;
                        fi
                    fi
                done
            else
                echo "> Cannot find rescuetime.deb"
                return 1
            fi
            return 0
        else
            echo "> Skipping....";
            return 0
        fi
    else
        echo "> Installed Already: Rescuetime"
    fi
}

install_calibre_ebook_managment()
{
    # http://calibre-ebook.com/download_linux
    echo "> Installing Calibre ebook manager"
    if require_package "python"; then
        sudo python -c "import sys; py3 = sys.version_info[0] > 2; u = __import__('urllib.request' if py3 else 'urllib', fromlist=1); exec(u.urlopen('http://status.calibre-ebook.com/linux_installer').read()); main()"
    else
        echo "> Failed to install Calibre"
    fi
}

if install_dropbox; then
    start_dropbox
fi
install "nautilus-dropbox" "Dropbox nautilus support"

install_rescuetime

install "chromium-browser" "Chromium Browser"
install "firefox"

if install "anki mecab mplayer" "Anki"; then
    install "dvipng" "Anki Latex support"
fi
install "goldendict" "Goldendict" 
install "wine mesa-utils" "Wine"
install "ibus-mozc" "Google Japanese IME"
if install "gtk-redshift redshift" "Redshift"; then
    install "geoclue geoclue-hostip" "Geoclue"
    if [ -e "./setup_redshift.sh" ]; then
        bash ./setup_redshift.sh
    fi
elif available "fluxgui"; then
    install "fluxgui" "F.lux (redshift is based off this)"
else
    if prompt "Install F.lux"; then
        bash ./setup_flux.sh
    fi
fi
install "dia" "DIA"
install "jupiter" "Jupiter power daemon"
install "cpufrequtils" "cpufrequtils"
install "gimp" "gimp image editor"
install "scrot" "scrot"
install "vlc" "vlc"
install "ubuntu-restricted-extras"
install "gnome-system-tools"
install "xchm"
if available "skype"; then
    install "skype" "Skype"
else
    if prompt "> Download skype with a browser"; then
        URL=http://www.skype.com/en/download-skype/skype-for-computer/
        echo "> Loading $URL"
        firefox "$URL" 2>&1 > /dev/null&
    fi
fi

if available "steam"; then
    install "steam"
else
    if prompt "> Download and install steam"; then
        STEAMURL="http://media.steampowered.com/client/installer/steam.deb"
        extract_url_filename "$STEAMURL"
        STEAMFILENAME="$URL_FILENAME"
        while true; do
            if wget "$STEAMURL"; then
                install_deb_file "$STEAMFILENAME"
                break
            else
                if ! prompt "> Try downloading $STEAMURL again"; then
                    break
                fi
            fi
        done
    fi
fi

if ! runnable "calibre"; then
    if prompt "> Install Calibre ebook manager (can export to kindle etc)"; then
        install_calibre_ebook_managment
    fi
else
    echo "> Installed Already: calibre"
fi

SOUNDCLOUDDL_REPO="https://github.com/lukapusic/soundcloud-dl"
SOUNDCLOUDDL_DESC="Soundcloud-dl script by lukapusic"
if ! runnable "soundcloud-dl.sh" && git_clone_prompt "$SOUNDCLOUDDL_REPO" "Install $SOUNDCLOUDDL_DESC"; then
    if [ -e "$REPO_DIRECTORY/soundcloud-dl.sh" ]; then
        if [ ! -d `echo ~/bin` ]; then
            mkdir `echo ~/bin`
        fi
        SCRIPT="$REPO_DIRECTORY/soundcloud-dl.sh"
        if [ ! -x "$SCRIPT" ]; then
            chmod u+x "$SCRIPT"
        fi
        create_link_from_to "$SCRIPT" `echo ~/bin/soundcloud-dl.sh` "soundcloud-dl.sh script" "Make a link of soundcloud-dl.sh to ~/bin"
    fi
else
    echo "> Installed Already: $SOUNDCLOUDDL_DESC"
fi

if ! installed "xbmc"; then
    if prompt "> Install XBMC"; then
        XBMC_REQUIRED_PACKAGES="python-software-properties pkg-config software-properties-common"
        #todo: break these up into available calls
        if require_package "$XBMC_REQUIRED_PACKAGES"; then
            if ! available "xbmc"; then
                while true; do
                    if sudo add-apt-repository ppa:team-xbmc/ppa; then
                        sudo apt-get update
                        break
                    elif ! prompt "> Try adding repository again"; then
                        break
                    fi
                done
            fi
            install "xbmc"
        fi
    fi
fi
