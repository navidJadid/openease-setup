#!/bin/sh

# If you call this script from within another script
# it might be necessary to use an absolute path.
# Otherwise there might be problems resolving the
# path to config.sh
source ./config.sh

# Make sure to set git.config accordingly, before running this script

function clone-repository-into-dir {
    echo "----------------------------------"
    cd $1                   # change to destination directory
    echo $PWD
    echo ""
    if [ -z "$3" ]
    then
        git clone $2        # normal git clone
    else
        git clone $2 $3     # clone repo ($2) with folder name ($3)
    fi
}

function create-recursive-dir {
    mkdir -p $1
}

function create-dir-if-non-existent {
    if [ ! -d "$1" ]
    then
        create-recursive-dir $1
    fi
}

function clone-openease-webapp {
    create-dir-if-non-existent $OPENEASE_PARENT_DIR
    clone-repository-into-dir $OPENEASE_PARENT_DIR $OPENEASE_REPO $OPENEASE
}

function clone-openease-node-modules {
    create-dir-if-non-existent $OPENEASE_NODE_MODULES_PATH
    clone-repository-into-dir $OPENEASE_NODE_MODULES_PATH $CANVAS_THREE_REPO $CANVAS_THREE
    clone-repository-into-dir $OPENEASE_NODE_MODULES_PATH $CHARTS_REPO $CHARTS
    clone-repository-into-dir $OPENEASE_NODE_MODULES_PATH $ROS_CLIENTS_REPO $ROS_CLIENTS
    clone-repository-into-dir $OPENEASE_NODE_MODULES_PATH $ROSPROLOG_REPO $ROSPROLOG

    create-dir-if-non-existent $ROSPROLOG_NODE_MODULES_PATH
    clone-repository-into-dir $ROSPROLOG_NODE_MODULES_PATH $ROS_CLIENTS_REPO $ROS_CLIENTS

}

function clone-openease {
    clone-openease-webapp
    clone-openease-node-modules
}

function clone-knowrob {
    create-dir-if-non-existent $KNOWROB_PARENT_DIR
    clone-repository-into-dir $KNOWROB_PARENT_DIR $KNOWROB_REPO $KNOWROB
}

function clone-dockerbridge {
    create-dir-if-non-existent $DOCKERBRIDGE_PARENT_DIR
    clone-repository-into-dir $DOCKERBRIDGE_PARENT_DIR $DOCKERBRIDGE_REPO $DOCKERBRIDGE
}

# ---------------------------------------------------------------

if [ -z "$OPENEASE_ROOT_DIR" ]
then
    echo "Path to workspace is not set."
    echo "Please set it and re-run this script."
else
    clone-openease
    clone-knowrob
    clone-dockerbridge
fi
