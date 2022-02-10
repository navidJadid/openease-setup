# folder names for the modules
# values can be changed as necessary
OPENEASE="openease"             # openease webapp-container
KNOWROB="knowrob"               # knowrob-container
DOCKERBRIDGE="dockerbridge"     # dockerbridge-container

# If all repositories have the same root directories, only
# change $OPENEASE_ROOT. If the openease, knowrob and dockerbridge
# repo should have different directories as root, change the following
# paths instead:
#   - OPENEASE_PARENT_DIR
#   - KNOWROB_PARENT_DIR
#   - DOCKERBRIDGE_PARENT_DIR
OPENEASE_ROOT_DIR=~/Documents/openease_workspace  # set the preferred path to your workspace
OPENEASE_PARENT_DIR="$OPENEASE_ROOT_DIR"
OPENEASE_WEBAPP_PATH="$OPENEASE_ROOT_DIR/$OPENEASE"

KNOWROB_PARENT_DIR="$OPENEASE_ROOT_DIR"
KNOWROB_PATH="$KNOWROB_PARENT_DIR/$KNOWROB"

DOCKERBRIDGE_PARENT_DIR="$OPENEASE_ROOT_DIR"
DOCKERBRIDGE_PATH="$DOCKERBRIDGE_PARENT_DIR/$DOCKERBRIDGE"

# repository HTTPS-links
# change whichever necessary to, e.g., your forks
OPENEASE_REPO="https://github.com/ease-crc/openease"
# KNOWROB_REPO https://github.com/ease-crc/knowrob_openease.git
KNOWROB_REPO="https://github.com/daniel86/knowrob.git"
DOCKERBRIDGE_REPO="https://github.com/ease-crc/openease_dockerbridge.git"
