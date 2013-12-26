#!/bin/bash

#
# Setup redshift config
#

REDSHIFT_CONFIG_FILE=`echo ~/.config/redshift.conf`
REDSHIFT_LOCAL_CONFIG_FILE=`pwd`/redshift.conf
REDSHIFT_CONFIG_FILE_DESCRIPTION="redshift config file"

echo "> Configuring redshift"

CONFIGURE_REDSHIFT=`true`

if are_files_identical "$REDSHIFT_CONFIG_FILE" "$REDSHIFT_LOCAL_CONFIG_FILE"; then
    if ! prompt "> Current $REDSHIFT_CONFIG_FILE_DESCRIPTION is identical to the one we will configure it to, use ours"; then
        CONFIGURE_REDSHIFT=`false`
    fi
fi

if $CONFIGURE_REDSHIFT; then  
    create_link_from_to_exit_on_fail "$REDSHIFT_LOCAL_CONFIG_FILE" "$REDSHIFT_CONFIG_FILE"  "Redshift config file" "Configure Redshift config file" "$REDSHIFT_CONFIG_FILE_DESCRIPTION"
fi
