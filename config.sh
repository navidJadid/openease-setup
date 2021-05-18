# folder names for the modules
# values can be changed as necessary
OPENEASE="openease"             # openease webapp-container
CANVAS_THREE="canvas-three"     # npm-package for webapp
CHARTS="charts"                 # npm-package for webapp
ROS_CLIENTS="ros-clients"       # npm-package for webapp
ROSPROLOG="rosprolog-console"   # npm-package for webapp
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
OPENEASE_NODE_MODULES_PATH="$OPENEASE_WEBAPP_PATH/node_modules/@openease"
CANVAS_THREE_PATH="$OPENEASE_NODE_MODULES_PATH/$CANVAS_THREE"
CHARTS_PATH="$OPENEASE_NODE_MODULES_PATH/$CHARTS"
ROS_CLIENTS_PATH="$OPENEASE_NODE_MODULES_PATH/$ROS_CLIENTS"
ROSPROLOG_PATH="$OPENEASE_NODE_MODULES_PATH/$ROSPROLOG"
ROSPROLOG_NODE_MODULES_PATH="$OPENEASE_NODE_MODULES_PATH/$ROSPROLOG/node_modules/@openease"
ROSPROLOG_ROS_CLIENTS_PATH="$ROSPROLOG_NODE_MODULES_PATH/$ROS_CLIENTS"

KNOWROB_PARENT_DIR="$OPENEASE_ROOT_DIR"
KNOWROB_PATH="$KNOWROB_PARENT_DIR/$KNOWROB"

DOCKERBRIDGE_PARENT_DIR="$OPENEASE_ROOT_DIR"
DOCKERBRIDGE_PATH="$DOCKERBRIDGE_PARENT_DIR/$DOCKERBRIDGE"

# repository HTTPS-links
# change whichever necessary to, e.g., your forks
OPENEASE_REPO="https://github.com/ease-crc/openease"
CANVAS_THREE_REPO="https://github.com/ease-crc/openease_threejs.git"
CHARTS_REPO="https://github.com/ease-crc/openease_d3.git"
ROS_CLIENTS_REPO="https://github.com/ease-crc/ros-js-clients.git"
ROSPROLOG_REPO="https://github.com/ease-crc/rosprolog-js-console.git"
# KNOWROB_REPO https://github.com/ease-crc/knowrob_openease.git
KNOWROB_REPO="https://github.com/daniel86/knowrob.git"
DOCKERBRIDGE_REPO="https://github.com/ease-crc/openease_dockerbridge.git"
