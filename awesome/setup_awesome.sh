#!/bin/bash

#
# Setup personal AwesomeWM environment
# Links ~/.config/awesome to a given folder
# By default we will look for rc.lua in ./awesomegit/ and use that folder
# If nothing is found, will try to git clone `cat gitrepo.txt`
#

AWESOME_CONFIG=`echo ~/.config/awesome`
AWESOME_CONFIG_LOCAL=`pwd`/awesomegit
AWESOME_GIT_REPO_FILE="gitrepo.txt"
AWESOME_CONFIG_GIT_REPO=`cat "$AWESOME_GIT_REPO_FILE" 2> /dev/null`
AWESOME_CONFIG_LOCAL_IS_REPO=false

echo "> Configuring AwesomeWM"
CONFIGURE_AWESOME=true
if [ ! -d "$AWESOME_CONFIG_LOCAL" ]; then
    if ! broken_link_delete_or_rename "$AWESOME_CONFIG_LOCAL"; then
        if ! ignore; then
            exit 1
        fi
    fi
    if ! rename_file "$AWESOME_CONFIG_LOCAL"; then
        if ! ignore; then
            exit 1
        fi
    fi
    echo ">> Awesome config folder does not exist.. creating"
    if ! mkdir "$AWESOME_CONFIG_LOCAL"; then
        echo ">> ERROR: No config folder for Awesome"
        if ! ignore; then
            exit 1
        fi
    fi
fi

# Check if repo exists
if [ -d "$AWESOME_CONFIG_LOCAL" ]; then
    directories=`find "$AWESOME_CONFIG_LOCAL" -maxdepth 1 -mindepth 1 -type d 2>/dev/null`
    if [ -z "$directories" ]; then
        if [ -n "$AWESOME_CONFIG_GIT_REPO" ]; then
            if prompt "> No local Awesomewm config git repo, clone $AWESOME_CONFIG_GIT_REPO"; then
                if ! require_package "git"; then
                    CONFIGURE_AWESOME=false
                else
                    cd "$AWESOME_CONFIG_LOCAL"
                    git_clone_and_submodule_init_update "$AWESOME_CONFIG_GIT_REPO"
                    if [ -n "$REPO_DIRECTORY" ]; then
                        cd "$REPO_DIRECTORY"
                        if [ -e "rc.lua" ]; then
                            AWESOME_CONFIG_LOCAL=`pwd`
                            AWESOME_CONFIG_LOCAL_IS_REPO=true
                        fi
                        cd -
                    fi
                    directories=`find "$AWESOME_CONFIG_LOCAL" -maxdepth 1 -mindepth 1 -type d 2>/dev/null`
                fi
            fi
        else
            if prompt "> No git repo given in config file $AWESOME_GIT_REPO_FILE and no config available, type one"; then
                if require_package "git"; then
                    cd "$AWESOME_CONFIG_LOCAL"
                    while true; do
                        read -p "> git repo: " repo
                        if git_clone_and_submodule_init_update "$repo"; then
                            if [ -n "$REPO_DIRECTORY" ]; then
                                cd "$REPO_DIRECTORY"
                                if [ -e "rc.lua" ]; then
                                    AWESOME_CONFIG_LOCAL=`pwd`
                                    AWESOME_CONFIG_LOCAL_IS_REPO=true
                                fi
                                cd -
                            fi
                            break
                        else
                            if ! prompt ">> Failed to git clone $repo, try again"; then
                                break
                            fi
                        fi
                    done
                fi
            fi
        fi
    fi
    if [ -n "$directories" ]; then
        echo ">> Searching for rc.lua in $AWESOME_CONFIG_LOCAL"
    fi
    rclua=`find "$AWESOME_CONFIG_LOCAL" -name 'rc.lua' 2>/dev/null`
    if [ -n "$rclua" ]; then
        rclua=$(echo $rclua | tr "\n" "\n")
        for i in $rclua; do
            echo ">> Found $i"
            if prompt ">> Use $i"; then
                AWESOME_CONFIG_LOCAL=`dirname $i`
                if [ -d "$AWESOME_CONFIG_LOCAL/.git" ]; then
                    if prompt ">> Directory $AWESOME_CONFIG_LOCAL is a git repo, pull and rebase"; then
                        cd "$AWESOME_CONFIG_LOCAL"
                        if require_package "git"; then
                            git pull && git rebase
                        fi
                    fi
                fi                            
                break
            fi
        done
    fi
fi
if [ -e "$AWESOME_CONFIG_LOCAL"/rc.lua ]; then
    create_link_from_to_exit_on_fail "$AWESOME_CONFIG_LOCAL" "$AWESOME_CONFIG" "AwesomeWM config" "Setup AwesomeWM to use our config file $AWESOME_CONFIG_LOCAL/rc.lua" "configure awesome with our config"
else
    echo ">> File $AWESOME_CONFIG_LOCAL/rc.lua does not exist"
    echo ">> Did not setup AwesomeWM"
    if ! ignore; then
        exit 1
    fi
fi
