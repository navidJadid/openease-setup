#!/bin/sh

# If you call this script from within another script
# it might be necessary to use an absolute path.
# Otherwise there might be problems resolving the
# path to config.sh
source ./config.sh

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

function create-parent-dirs-and-clone-repository {
    create-dir-if-non-existent $1
    clone-repository-into-dir $1 $2 $3
}

function clone-openease {
    create-parent-dirs-and-clone-repository $OPENEASE_PARENT_DIR $OPENEASE_REPO $OPENEASE
}

function clone-knowrob {
    create-parent-dirs-and-clone-repository $KNOWROB_PARENT_DIR $KNOWROB_REPO $KNOWROB
}

function clone-dockerbridge {
    create-parent-dirs-and-clone-repository $DOCKERBRIDGE_PARENT_DIR $DOCKERBRIDGE_REPO $DOCKERBRIDGE
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
