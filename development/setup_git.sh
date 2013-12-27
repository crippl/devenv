#!/bin/bash

#
# Setup git config
#

GITCONFIG=`echo ~/.gitconfig`

configure_git_option() {
    # $1: Option to configure
    # $2: String in config file
    # $3: Description

    OPTION="$1"
    CONFIG_STRING="$2"
    DESCRIPTION="$3"
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="$1"
    fi

    if ! already_in_file "$GITCONFIG" "$CONFIG_STRING"; then
        read -p ">> GIT $DESCRIPTION: " VALUE
        git config --global "$OPTION" "$VALUE"
        return $?
    fi
}

configure_git_option "user.name" "name =" "User name"
configure_git_option "user.email" "email =" "Email address"
