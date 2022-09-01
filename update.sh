#!/bin/sh

# If you call this script from within another script
# it might be necessary to use an absolute path.
# Otherwise there might be problems resolving the
# path to config.sh
source ./config.sh

# Make sure to set git.config accordingly, before running this script

# Option flags
UPDATE_FROM_REMOTE="-u"
BUILD_CONTAINERS="-b"
HELP="-h"

# ---------------------------------------------------------------

function pull-in-current-dir {
    git remote get-url origin
    git rev-parse --abbrev-ref HEAD
    git pull
}

function go-to-directory-and-pull {
    echo "----------------------------------"
    cd $1
    echo $PWD
    echo ""
    pull-in-current-dir
}

function update-all-directories-from-remote {
    echo "Updating local repositories from remote origin..."
    echo ""
    for LOCAL_PATH in   $OPENEASE_WEBAPP_PATH \
                        $KNOWROB_PATH \
                        $DOCKERBRIDGE_PATH \
                        $OPENEASE_WEBAPP_PATH; do
        go-to-directory-and-pull $LOCAL_PATH
    done
}

KNOWROB_DOCKER="$KNOWROB_PATH/docker"

WEBAPP_CONTAINER="openease/app"
KNOWROB_CONTAINER="openease/knowrob"
DOCKERBRIDGE_CONTAINER="openease/dockerbridge"

function build-container {
    echo "----------------------------------"
    cd $1
    echo $PWD
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]] && [[ $(uname -m) == "arm64" ]]; then
        docker build -t $2 --platform linux/amd64 .
    else
    docker build -t $2 .
    fi
}

function build-all-containers {
    echo "Updating docker containers..."
    echo ""
    build-container $OPENEASE_WEBAPP_PATH $WEBAPP_CONTAINER
    build-container $KNOWROB_DOCKER $KNOWROB_CONTAINER
    build-container $DOCKERBRIDGE_PATH $DOCKERBRIDGE_CONTAINER
}

function print-separator-lines {
    echo "----------------------------------"
    echo ""
}

function print-help-statements {
    echo "Help Information"
    echo ""
    echo "If this script is called without any parameters, it"
    echo "will update all the repositories from remote:origin"
    echo "and build all the containers after the update."
    echo ""
    echo "Option flags include:"
    echo "-h: display help; takes priority over other flags"
    echo "-u: update all the repositories from remote:origin"
    echo "-b: builds all the docker containers of this project"
}

function print-unknown-flag-statements {
    echo "Unknown Option Flags!"
    echo "See help with option flag '-h'"
    echo ""
    print-help-statements
}

# ---------------------------------------------------------------

if [[ -z "$@" ]]; 
then
    Y="y"
    YES="yes"
    N="n"
    NO="no"

    echo "Proceed to update all repositories and build"
    echo "all containers? [y/n]"

    read user_input

    lowercase_input=${user_input}
    echo ""

    proceed=false

    while [[ $lowercase_input != $Y \
            && $lowercase_input != $YES \
            && $lowercase_input != $N \
            && $lowercase_input != $NO ]]; do
        echo "Input was not valid, please enter only 'yes' or 'no'."
        read user_input
        lowercase_input=${user_input,,}
        echo ""
    done

    if [[ $lowercase_input == $Y || $lowercase_input == $YES ]]
    then
        proceed=true
    fi
    
    if [ $proceed == true ]
    then
        update-all-directories-from-remote
        print-separator-lines
        build-all-containers
    else
        echo "Aborted actions"
    fi
    
else
    option_flags_are_valid=true

    for ITEM in "$@"
    do
        if [[ $ITEM != $UPDATE_FROM_REMOTE && $ITEM != $BUILD_CONTAINERS && $ITEM != $HELP ]]
        then
            option_flags_are_valid=false
        fi
    done

    if [ $option_flags_are_valid == false ]
    then
        print-unknown-flag-statements
    else
        help_flag_was_set=false

        for ITEM in "$@"
        do
            if [ $ITEM == $HELP ]
            then
                help_flag_was_set=true
            fi
        done
        
        if [ $help_flag_was_set == true ]
        then
            print-help-statements
        else
            for ITEM in "$@"
            do
                if [ $ITEM == $UPDATE_FROM_REMOTE ]
                then
                    update-all-directories-from-remote
                    break
                fi
            done

            for ITEM in "$@"
            do
                if [ $ITEM == $BUILD_CONTAINERS ]
                then
                    for ITEM in "$@"
                    do
                        if [ $ITEM == $UPDATE_FROM_REMOTE ]
                        then
                            print-separator-lines
                            break
                        fi
                    done
                    build-all-containers  
                    break
                fi
            done
        fi
    fi
fi
