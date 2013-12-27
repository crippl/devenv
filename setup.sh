#!/bin/bash
#
# Install various personal applications
#

#set -x

# File containing everything to install with one command
# apt-get install `cat "$TOINSTALLFILE"`
TOINSTALLFILE=`echo ~/.to_install`
export TOINSTALLFILE

# Change current directory to that of the script
# Specific to bash
# from http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

APT_CACHE_SLOW=false
export APT_CACHE_SLOW

PROMPT_FORCE_ANSWER=""
export PROMPT_FORCE_ANSWER

prompt() {
    # $1: Text to prompt to user
    # Returns: 0 on yes, 1 on no
    while true; do
        if [ -n "$PROMPT_FORCE_ANSWER" ]; then
            yn="$PROMPT_FORCE_ANSWER"
        else
            read -p "$1 ? (Yes/No): " yn
        fi
        case $yn in
            [Yy]*)
                return 0
                ;;
            [Nn]*)
                return 1
                ;;
            * ) echo "Din't get that. Was it a 'y' or a 'n' ?";;
        esac
    done
}
export -f prompt

ignore() {
    # Prompts user to ignore an error
    # Returns: 0 for yes, 1 for no
    prompt "> Ignore this error"
    return $?
}
export -f ignore

RESOLVED_SYMLINK=echo
export RESOLVED_SYMLINK

resolve_symlink () {
    # $1: Path to file
    # Returns: success/failure
    # $RESOLVED_SYMLINK: Resolved symlink

    FILE="$1"
    #check if it does not exist
    if [ ! -e "$FILE" ]; then
	FILE=`which "$FILE"`
	if [ ! -e "$FILE" ]; then
	    echo "File does not appear to exist"
	    exit 1
	fi
    fi
    #check if it is a symlink
    if [ -h "$FILE" ]; then
	lnk=`readlink "$FILE"`
	resolve_symlink "$lnk"
        retval="$?"
        if [ "$?" == 0 ]; then
            RESOLVED_SYMLINK="$FILE"
        fi
        return "$retval"
    else
        RESOLVED_SYMLINK="$FILE"
    fi
}
export -f resolve_symlink

UNIQUEFILENAME=""
export UNIQUEFILENAME

generate_unique_filename() {
    # $1: Path to file
    # $2: Hint to a new filename
    # Returns: $UNIQUEFILENAME
    while : ; do
        if [ -n "$2" ]; then
            UNIQUEFILENAME="$2"
            2=""
        else
            UNIQUEFILENAME="$1.$RANDOM"
        fi
        [[ -e "$UNIQUEFILENAME" ]] || break
    done
}
export -f generate_unique_filename

RENAMED_FILE=""
export RENAMED_FILE

rename_file() {
    # $1: Path to file to rename
    # Returns: success/failure
    # RENAMED_FILE: New file's name

    generate_unique_filename "$1" "$1.old"
    NEWFILENAME="$UNIQUEFILENAME"
    while [ -e "$1" ]; do
        if prompt ">> Rename $1 to $NEWFILENAME"; then
            # cd to directory incase user inputs nonabsolute filename
            cd `dirname "$1"`
            mv "$1" "$NEWFILENAME"
            cd -
            break;
        else
            if prompt ">> Input a name yourself"; then
                read -p ">> " NEWFILENAME
            else
                if prompt ">> Give up"; then
                    return 1
                fi
            fi
        fi
    done
    RENAMED_FILE="$NEWFILENAME"
}
export -f rename_file

file_exists_or_print_error() {
    # $1: Description of file
    # $2: Path to file
    # Returns: Failure if file does not exist
    if [ ! -e "$2" ]; then
        echo "> ERROR: Can't find $1: $2" >&2
        return 1
    fi
}
export -f file_exists_or_print_error

is_a_broken_link() {
    # $1: File to check if a broken link
    # Returns: Success if a broken link
    if [ -h "$1" ] && [ ! -e "$1" ]; then
        return 0
    else
        return 1
    fi
}
export -f is_a_broken_link

broken_link_delete_or_rename() {
    # $1: Broken link to delete or rename
    # Returns: Success if deleted or renamed, failure otherwise
    if is_a_broken_link "$1"; then
        if prompt ">> $1 is a broken link, delete"; then
            rm -f "$1"
        else
            if ! rename_file "$1"; then
                return 1
            fi
        fi
    fi
}
export -f broken_link_delete_or_rename

create_link_from_to() {
    # $1: File/Folder to point to
    # $2: New link
    # $3: Description of file (optional)
    # $4: Description of what we are doing (optional)

    LINK_TO="$1"
    LINK_FROM="$2"
    LINK_DESCRIPTION="$3"
    WHAT_ARE_WE_DOING="$4"

    if [ -z "$LINK_DESCRIPTION" ]; then
        LINK_DESCRIPTION="$LINK_FROM"
    fi
    if [ -z "$WHAT_ARE_WE_DOING" ]; then
        WHAT_ARE_WE_DOING="Link $LINK_FROM to $LINK_TO"
    fi


    RENAME=true
    ALREADY_LINKED=false

    if ! file_exists_or_print_error "$LINK_DESCRIPTION" "$LINK_TO"; then
        return 1
    else
        if [ -e "$LINK_FROM" ]; then
            if [ -h "$LINK_FROM" ]; then
                # It is a symbolic link
                # If it points to us, then do nothing
                if is_a_broken_link "$LINK_TO"; then
                    pointsto=`ls -l "$LINK_TO"`
                    echo ">> ERROR: $LINK_TO is a broken link (pointing to $pointsto)"
                    return 1
                fi
                CURRENT_RESOLVED_SYMLINK="$RESOLVED_SYMLINK"
                resolve_symlink "$LINK_FROM"
                CURRENT_LINK_POINTS_TO="$RESOLVED_SYMLINK"
                resolve_symlink "$LINK_TO"
                CURRENT_LINK_TO_POINTS_TO="$RESOLVED_SYMLINK"
                RESOLVED_SYMLINK="$CURRENT_RESOLVED_SYMLINK"
                if [ "$CURRENT_LINK_TO_POINTS_TO" != "$CURRENT_LINK_POINTS_TO" ]; then
                    if ! prompt ">> Current $LINK_DESCRIPTION links to ($CURRENT_LINK_POINTS_TO), rename it and continue"; then
                        return 1
                    else
                        RENAME=true
                    fi
                else
                    echo ">> $LINK_DESCRIPTION file already linked"
                    ALREADY_LINKED=true
                    RENAME=false
                fi
            else
                RENAME=true
                if ! prompt ">> A $LINK_DESCRIPTION exists ($LINK_FROM), rename it"; then
                    return 1
                fi
            fi
            if [ -e "$LINK_FROM" ] && [ $RENAME == true ]; then
                # rename the file
                if ! rename_file "$LINK_FROM"; then
                    return 1
                fi
            fi
        else
            broken_link_delete_or_rename "$LINK_FROM"
            if ! prompt ">> $WHAT_ARE_WE_DOING"; then
                return 1
            fi
        fi
        if [ ! -e "$LINK_FROM" ]; then
            echo ">> Linking $LINK_TO to $LINK_FROM"
            ln -s "$LINK_TO" "$LINK_FROM"
        else
            if [ $ALREADY_LINKED == false ]; then
                echo ">> Not linking $LINK_TO to $LINK_FROM, file already exists"
            fi
        fi
    fi
}
export -f create_link_from_to

create_link_from_to_exit_on_fail() {
    # $1-$4: See create_link_from_to
    # $5: What did we fail to do; will prompt user
    
    if ! create_link_from_to "$1" "$2" "$3" "$4"; then
        echo ">> Failed to $5" >&2
        if ! ignore; then
            exit 1
        fi
    fi
}
export -f create_link_from_to_exit_on_fail

are_files_identical() {
    # $1: File one
    # $2: File two
    # Returns: If two files are identical/both do not exist, failure if only one exists
    if [ ! -e "$1" ] && [ ! -d "$1" ]; then
        if [ ! -e "$2" ] && [ ! -d "$2" ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi

    diff "$1" "$2" > /dev/null
    return $?
}
export -f are_files_identical


isrunning () {
    # $1: Process name to search if is running
    # Returns: success if process is running, failure otherwise

    #search pgrep for something that is not us
    for PID in `pgrep -f $1`; do
        if [ $PID -eq $$ ]; then
	    echo found this pid
        else
	    #found something else that is not us
	    #exit, its already running
	    return 0
        fi
    done
    #its not running...
    return 1
}
export -f isrunning

runnable() {
    # $1: Command to check if runnable
    # Returns: success/failure
    # Checks if the specified command is runnable in the current path
    hash dropbox 2>/dev/null
    return $?
}
export -f runnable

REPO_DIRECTORY=""
export REPO_DIRECTORY

git_clone_and_submodule_init_update() {
    # $1: Git repo
    # Returns: Success on successfull clone
    # REPO_DIRECTORY: Directory of cloned repo
    REPO_DIRECTORY=""
    if ! require_command "git" "git"; then
        return 1
    fi
    if git clone "$1"; then
        REPO_DIRECTORY=`basename "$1"`
        if [ -d "$REPO_DIRECTORY" ]; then
            cd "$REPO_DIRECTORY";
            REPO_DIRECTORY=`pwd`
            git submodule init && git submodule update
            cd -
        fi
    else
        return 1
    fi
}
export -f git_clone_and_submodule_init_update

POSTINSTALL="$DIR/postinstall.sh"
export POSTINSTALL

clear_file() {
    # Prompts user to delete a file
    # $1: Path to file
    # $2: Description of file (optional)
    # Returns: success if file was deleted, failure otherwise

    FILE="$1"
    DESCRIPTION="$2"
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="$FILE"
    fi
    if [ -e "$FILE" ]; then
        if prompt "> $DESCRIPTION file already exists, delete"; then
            failure=0
            if [ -d "$FILE" ]; then
                rmdir "$FILE"
                failure=$?
            else
                rm -f "$FILE"
                failure=$?
            fi

            if [ "$failure" == 0 ]; then
                echo "> Deleted old $DESCRIPTION file"
            else
                echo "> Failed to Delete Old $DESCRIPTION file, exiting"
                exit 1
            fi
        fi
    fi
}
export -f clear_file

available() {
    # Checks if a package is available in apt-get install
    # $1: Package to check for
    # Returns: success if available, failure otherwise

    # apt-cache policy will print nothing to stdout if nothing found
    tmp=`apt-cache policy "$1"`
    return `[ -n "$tmp" ]`
}
export -f available

already_in_file() {
    # Checks if a string is in a file
    # $1: Path to File
    # $2: Text to search for
    # Returns: success if text is in file, failure otherwise

    if [ -f "$1" ]; then
        tmp=`cat "$1" 2> /dev/null | grep "$2" 2> /dev/null`
        return `[ -n "$tmp" ]`
    else
        return 1
    fi
}
export -f already_in_file

installed() {
    # Checks if a package is installed via apt-get
    # $1: Package to check for
    # Returns: success if installed, failure otherwise

    # Checks apt-cache policy for Installed: (none)
    if available "$1"; then
        START=$(date +%s)
        tmp=`apt-cache policy "$1" | grep Installed: | grep "none"`
        END=$(date +%s)
        DIFF=$(( $END - $START ))
        if [ "$DIFF" -ge 2 ]; then # running slow... should run apt-get autoclean
            APT_CACHE_SLOW=true
        fi
        return `[ -z "$tmp" ]`
    else
        return 1
    fi
}
export -f installed

MISSINGPACKAGES=`echo ~/to_install_missingpackages`
export MISSINGPACKAGES

install() {
    # Prompts user to install a package if the package is not installed
    # $1 is a space separated list of packages to install
    # $2 is the package to display to user (Optional)
    # Returns: success if user wants to install, failure otherwise

    PACKAGES="$1"
    DESCRIPTION="$2"

    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="$PACKAGES"
    fi

    #Check if any of these packages are already installed
    #Split $2 by spaces and iterate over them
    array=$(echo $PACKAGES | tr " " "\n")
    toinstall=""
    installed=""
    notavailable=""
    if [ "$APT_CACHE_SLOW" == true ]; then
        echo "> Checking if installed: $DESCRIPTION"
    fi
    for x in $array
    do
        # check if this is already installed
        if ! installed "$x"; then
            if already_in_file "$TOINSTALLFILE" "$x"; then
                echo ">> **Already installing $x, skipping"
            else
                if available "$x"; then
                    toinstall="$x $toinstall"
                else
                    if ! already_in_file "$MISSINGPACKAGES" "$x"; then
                        echo -n "$x " >> "$MISSINGPACKAGES"
                    fi
                    notavailable="$notavailable $x"
                fi
            fi
        else
            installed="$x $installed"
        fi
    done

    if [ -z "$toinstall" ] && [ -z "$installed" ] && [ -n "$notavailable" ]; then
        # nothing to install, nothing installed, things not available; problem
        echo "> Cannot Install   : $DESCRIPTION" >&2
        echo ">> Missing  : $notavailable" >&2
        return 1
    elif [ -z "$toinstall" ] && [ -n "$notavailable" ]; then
        # nothing to install, things unavailable to install
        echo "> Installed kindof : $DESCRIPTION" >&2
        echo ">> Installed: $installed"
        echo ">> Missing  : $notavailable" >&2
    elif [ -n "$toinstall" ]; then
        # things to install
        #echo "> Installing $DESCRIPTION"
        if [ "$DESCRIPTION" == "$PACKAGES" ]; then
            # Description was not given, don't show all packages to install, just those that can be installed
            DESCRIPTION="$toinstall"
        fi
        if prompt "> Install $DESCRIPTION"; then
            if [ -n "$notavailable" ]; then
                if ! prompt "> Notice: the following packages are not available \"$notavailable\"... continue"; then
                    return 1
                fi
            fi
            echo "> Added $DESCRIPTION to install file"
            echo -n "$toinstall " >> "$TOINSTALLFILE"
            return 0
        else
            #echo "> Skipping....";
            return 1
        fi
    else
        echo "> Installed Already: $DESCRIPTION"
    fi
    return 0
}
export -f install

install_now() {
    # $1: Package(s) to install now
    # $2: Description of package (optional)

    INSTALL="$1"
    DESCRIPTION="$2"

    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="$INSTALL"
    fi

    if ! installed "$INSTALL"; then
        while true; do
            if prompt ">> $DESCRIPTION Must be installed to continue"; then
                while true; do
                    if ! sudo apt-get install "$INSTALL"; then
                        if ! prompt ">> Installation failed, try again"; then
                            return 1
                        fi
                    else
                        break
                    fi
                done
                break
            else
                if prompt ">> Do not install $DESCRIPTION"; then
                    return 1
                fi
            fi
        done
    fi
}
export -f install_now

require_command() {
    # $1: Command to try to run
    # $2: Package to install if not available

    if ! available "$1"; then
        if ! install_now "$2" "$2"; then
            return 1
        else
            available "$1"
            return $?
        fi
    fi
}
export -f require_command

####################################################
#                End of functions                  #
####################################################

ASTERISKS=""
for i in `awk 'BEGIN { for( i=1; i<=50; i++ ) print i }'`; do
    ASTERISKS="$ASTERISKS*"
done
export ASTERISKS

if [ -z "$1" ]; then
    # No options given, do default behaviour
    echo "> TODO fornow need command line args"
elif [ "$1" == "install" ]; then
    # Install option given; run installation of chosen packages
    packages=`cat "$TOINSTALLFILE" 2> /dev/null`
    if [ -n "$packages" ]; then
        echo "> Running sudo apt-get install $packages"
        sudo apt-get install $packages
        retval=$?
        if [ "$retval" != 0 ]; then
            echo
            echo "$ASTERISKS"
            echo "> Installation failed, rerun with"
            echo "> sudo apt-get install \`cat $TOINSTALLFILE\`"
            echo "$ASTERISKS"
            exit $retval
        else
            if [ -f "$POSTINSTALL" ]; then
                echo "> Running post installation routines"
                if [ `bash "$POSTINSTALL"` ]; then
                    echo "> Postinstall finished successfully, cleaning up"
                    rm -f "$POSTINSTALL"
                else
                    echo "$ASTERISKS"
                    echo "> Postinstall failed, to rerun: "
                    echo "> bash $POSTINSTALL"
                    echo "$ASTERISKS"
                fi
            else
                echo "> No post install scripts detected"
            fi
        fi
    else
        echo "> Nothing to install"
    fi
    if [ -e "$MISSINGPACKAGES" ]; then
        missing=`cat "$MISSINGPACKAGES"`
        if [ -n "$missing" ]; then
            echo "> The following packages were not available to install:"
            echo "$missing"
            echo "> The list can be found at $MISSINGPACKAGES"
        fi
    fi
elif [ "$1" == "clear" ]; then
    # Promp user to clear temp files we use
    clear_file "$TOINSTALLFILE" "To install"
    clear_file "$POSTINSTALL" "Post install"
    clear_file "$MISSINGPACKAGES" "Missing package"
elif [ "$1" == "clean" ]; then
    # Delete temp files we use
    rm -f "$TOINSTALLFILE"
    rm -f "$POSTINSTALL"
    rm -f "$MISSINGPACKAGES"
else
    # Other option given: Run the script for that directory
    if [ -d "./$1" ]; then
        if [ -f "./$1/setup.sh" ]; then
            cd "$1"
            bash ./setup.sh
            if "$APT_CACHE_SLOW"; then
                echo "> 'apt-cache policy' command seemed to run slow, you can try running 'sudo apt-get autoclean' to fix this"
            fi
            exit 0
        else
            echo "> File does not exist $DIR/$1/setup.sh"
            exit 1
        fi
    else
        echo "> Folder does not exist $DIR/$1"
        exit 1
    fi
fi
