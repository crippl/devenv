#!/bin/bash

#
# Download and install the latest linux Android SDK from 
# http://developer.android.com/sdk/index.html#download
#

PACKAGE_NAME="Android SDK Bundle"

echo "> Installing $PACKAGE_NAME"

MACHINE_TYPE=`uname -m`
ANDROIDSTRING="adt-bundle-linux-$MACHINE_TYPE"
ANDROIDURL="http://developer.android.com/sdk/index.html#download"

echo "> Retrieving latest adt-bundle url.."
# url extraction from http://stackoverflow.com/questions/1881237/easiest-way-to-extract-the-urls-from-an-html-page-using-sed-or-awk-only
while true; do
    DOWNLOADURL=`wget -O - "$ANDROIDURL" | grep -o -E '\b(([\w-]+://?|dl[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))' | grep "$ANDROIDSTRING"`

    if [ -z "$DOWNLOADURL" ]; then
        if ! prompt "> Failed to retrieve linux adt-bundle url.. try again"; then
            return 1
        fi
    else
        break
    fi
done
DOWNLOADURL="http://$DOWNLOADURL"
echo "$DOWNLOADURL"
extract_url_filename "$DOWNLOADURL"
DOWNLOADFILENAME="$URL_FILENAME"

DOWNLOAD=true
if [ -e "$DOWNLOADFILENAME" ]; then
    if prompt "> File $DOWNLOADFILENAME exists, install that"; then
        DOWNLOAD=false
    fi
fi

if [ $DOWNLOAD == true ]; then
    while true; do
        if [ -e "$DOWNLOADFILENAME" ]; then
            if ! rename_file "$DOWNLOADFILENAME"; then
                if ! prompt "> Overwrite the file with the new downloaded version"; then
                    echo "> Quitting"
                    return 1
                fi
            fi
        fi
        echo "> Trying to download $DOWNLOADURL"
        echo ">"
        if ! wget -O "$DOWNLOADFILENAME" "$DOWNLOADURL"; then
            if ! prompt "> Failed to download $DOWNLOADURL, try again"; then
                return 1
            else
                rm "$DOWNLOADFILENAME"
            fi
        else
            break
        fi
    done
else
    echo "> Not downloading: Installing $DOWNLOAFILENAME"
fi

if [ ! -e "$DOWNLOADFILENAME" ]; then
    echo "> Cannot find $DOWNLOADFILENAME that we just downloaded, failing"
    return 1
fi

if ask_user_where_to_extract_file_at "$DOWNLOADFILENAME" "$PACKAGE_NAME"; then
    cd "$USERREQUESTED_FOLDER"
    ANDROIDABSPATH="$USERREQUESTED_FOLDER_FILE_ABSPATH"
    while true; do
        echo "> Installing $PACKAGE_NAME to $USERREQUESTED_FOLDER"
        if ! unzip "$ANDROIDABSPATH"; then
            if ! prompt "> Failed to extract $PACKAGE_NAME, try again"; then
                return 1
            fi
        else
            echo "> Installed $PACKAGE_NAME"
            break
        fi
    done
fi

