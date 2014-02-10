#!/bin/bash
#
# AwesomeWM Post Installation
#  Make sure that awesome.desktop is displayed in lightDM
#
MODULE="AwesomeWM"
CONFIGFILE="/usr/share/xsessions/awesome.desktop"
DONTDISPLAY="NoDisplay=true"
DODISPLAY="NoDisplay=false"
MESSAGE="Configuring AwesomeWM to showup in desktop chooser"
NOTHING="Nothing to do"
COMMAND="sudo sed s/$DONTDISPLAY/$DODISPLAY/ -i $CONFIGFILE"
COMMAND2="sudo echo $DODISPLAY >> \"$CONFIGFILE\""

# Replaces NoDisplay=false to NoDisplay=true in /usr/share/xsessions/awesome.desktop
# This allows it to be shown in the desktop chooser (lightDM/GDM/KDM etc)
# And seems to be an issue at least in ubuntu

if [ -e "$CONFIGFILE" ]; then
    if already_in_file "$CONFIGFILE" "$DONTDISPLAY"; then
        # Replace $DONTDISPLAY with $DODISPLAY
        info "$MODULE" "$MESSAGE"
        run_command_promp_user_if_fail "$COMMAND"
    elif ! already_in_file "$CONFIGFILE" "$DODISPLAY"; then
        # $DONTDISPLAY And $DODISPLAY are not in the config file, add it
        info "$MODULE" "$MESSAGE"
        run_command_promp_user_if_fail "$COMMAND2"
    else
        info "$MODULE" "$NOTHING"
    fi
else
    info "$MODULE" "$CONFIGFILE Does not exist, $NOTHING"
fi
