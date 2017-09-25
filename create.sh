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
  -e XAUTHORITY=/tmp/.Xauthority \
  -it\
  $1
