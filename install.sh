#!/bin/sh

# Make sure to set git.config accordingly, before running this script

# folder names
OPENEASE="openease"
CANVAS_THREE="canvas-three"
CHARTS="charts"
ROS_CLIENTS="ros-clients"
ROSPROLOG="rosprolog-console"
KNOWROB="knowrob"
DOCKERBRIDGE="dockerbridge"

# If all repositories have the same root directories, only
# change $OPENEASE_ROOT_PATH. If the knowrob and dockerbridge repo
# have different directories as root, change their paths as well.
OPENEASE_ROOT_PATH=~/Documents/openease_workspace  # set the path to your preferred workspace
OPENEASE_WEBAPP_PATH="$OPENEASE_ROOT_PATH/$OPENEASE"
OPENEASE_NODE_MODULES_PATH="$OPENEASE_WEBAPP_PATH/node_modules/@openease"
ROSPROLOG_NODE_MODULES_PATH="$OPENEASE_WEBAPP_PATH/node_modules/@openease/$ROSPROLOG/node_modules/@openease"
KNOWROB_PATH="$OPENEASE_ROOT_PATH"
DOCKERBRIDGE_PATH="$OPENEASE_ROOT_PATH"

# change whichever necessary to, e.g., your forks
OPENEASE_REPO="https://github.com/ease-crc/openease.git"
CANVAS_THREE_REPO="https://github.com/ease-crc/openease_threejs.git"
CHARTS_REPO="https://github.com/ease-crc/openease_d3.git"
ROS_CLIENTS_REPO="https://github.com/ease-crc/ros-js-clients.git"
ROSPROLOG_REPO="https://github.com/ease-crc/rosprolog-js-console.git"
KNOWROB_REPO="https://github.com/daniel86/knowrob.git"      # https://github.com/ease-crc/knowrob_openease.git
DOCKERBRIDGE_REPO="https://github.com/ease-crc/openease_dockerbridge.git"

# ---------------------------------------------------------------

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
    create-dir-if-non-existent $OPENEASE_ROOT_PATH
    clone-repository-into-dir $OPENEASE_ROOT_PATH $OPENEASE_REPO $OPENEASE
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
    create-dir-if-non-existent $KNOWROB_PATH
    clone-repository-into-dir $KNOWROB_PATH $KNOWROB_REPO $KNOWROB
}

function clone-dockerbridge {
    create-dir-if-non-existent $DOCKERBRIDGE_PATH
    clone-repository-into-dir $DOCKERBRIDGE_PATH $DOCKERBRIDGE_REPO $DOCKERBRIDGE
}

# ---------------------------------------------------------------

if [ -z "$OPENEASE_ROOT_PATH" ]
then
    echo "Path to workspace is not set."
    echo "Please set it and re-run this script."
else
    clone-openease
    clone-knowrob
    clone-dockerbridge
fi
