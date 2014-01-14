#!/bin/bash

#
# Download and install jdk6
#

# based on https://ivan-site.com/2012/05/download-oracle-java-jre-jdk-using-a-script/

#JDK 7u45

#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-arm-vfp-hflt.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-arm-vfp-sflt.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-i586.rpm
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-macosx-x64.dmg
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-i586.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-x64.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-sparc.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-sparc.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-sparcv9.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-solaris-sparcv9.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-windows-i586.exe
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-windows-x64.exe
#JDK 6u45

#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-i586.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-i586.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-sparc.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-sparc.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-sparcv9.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-sparcv9.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-x64.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-solaris-x64.tar.Z
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-windows-i586.exe
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-windows-x64.exe
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-ia64-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-ia64.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-windows-ia64.exe
#JRE 7u45

#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-linux-i586.rpm
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-linux-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-linux-x64.rpm
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-linux-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-macosx-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-solaris-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-solaris-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-solaris-sparc.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-solaris-sparcv9.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-windows-i586-iftw.exe
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-windows-i586.exe
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-windows-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-windows-x64.exe
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-windows-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-linux-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-solaris-i586.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-solaris-sparc.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-solaris-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-solaris-sparcv9.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-windows-x64.tar.gz
#JRE 6u45

#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-i586-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-i586.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-x64-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-x64.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-solaris-i586.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-solaris-sparc.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-solaris-sparcv9.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-solaris-x64.sh
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-windows-i586-iftw.exe
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-windows-i586.exe
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-windows-x64.exe
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-ia64-rpm.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-linux-ia64.bin
#http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jre-6u45-windows-ia64.exe

#TODO: check if jdk6 is installed
echo "> Installing JDK6"

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    JDKURL='http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin'
else
    JDKURL='http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin'
fi

# get filename to be downloaded
# from http://stackoverflow.com/questions/1199613/extract-filename-and-path-from-url-in-bash-script
AFTER_SLASH=${JDKURL##*/}
JDKFILE=`echo "${AFTER_SLASH%%\?*}"`
DOWNLOAD=true
while true; do
    if [ -e "$JDKFILE" ] && prompt "> $JDKFILE exists, install that"; then
        DOWNLOAD=false
    fi
    if [ $DOWNLOAD == true ]; then
        wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "$JDKURL"
    fi

    if [ -e "$JDKFILE" ]; then
        if ! absolute_path_of_file "$JDKFILE"; then
            echo "> Cannot get absolute path of file $JDKFILE, failing"
            return 1
        fi
        JDKABSOLUTEPATH="$ABSOLUTE_PATH"
        if input_valid_directory "> Where do you want to install the jdk to"; then
            cd "$DIRECTORY"
        else
            echo "> Installing to your home folder"
            cd ~
        fi
        if [ ! -x "$JDKABSOLUTEPATH" ]; then
            chmod u+x "$JDKABSOULTEPATH"
        fi
        while true; do
            echo "Running: '$JDKABSOLUTEPATH'"
            if "$JDKABSOLUTEPATH"; then
                break; #success
            else
                if ! prompt "> Failed to install $JDKFILE from $JDKURL, try again"; then
                    break;
                fi
            fi
        done
        break;
    else
        if ! prompt "> Failed to download $JDKURL, try again"; then
            break;
        fi
    fi
done
