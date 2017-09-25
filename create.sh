#!/bin/bash

# Check args
if [ "$#" -ne 2 ]; then
  echo "usage: ./run.sh IMAGE_NAME CONTAINER_NAME"
  exit 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ~/iarc7
fi

set -e

# Run the container with shared X11
docker create\
  --net=host\
  --name=$2\
  -e SHELL\
  -e DISPLAY=$DISPLAY\
  -e DOCKER=1\
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
  -v $HOME/.Xauthority:/tmp/.Xauthority \
  -v $HOME/iarc7:$HOME/iarc7 \
  -e XAUTHORITY=/tmp/.Xauthority \
  -it\
  $1
