#!/bin/bash
DIRECTORY=~/iarc7

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
    mkdir -p ~/iarc7 && \
    rosdep update && \
    cd ~/iarc7 && \
    git clone https://github.com/Pitt-RAS/iarc7_common.git && \
    source /opt/ros/kinetic/setup.bash && \
    wstool init src iarc7_common/main.rosinstall && \
    rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y && \
    cd ~/iarc7 && \
    wstool merge -t src iarc7_common/simulator.rosinstall && \
    wstool update -t src && \
    cd ~/iarc7 && \
    cd src/iarc7_simulator && \
    morse import sim && \
    cd ~/iarc7 && \
    catkin_make && \
    echo "source ~/iarc7/devel/setup.bash" >> ~/.bashrc && \
    source ~/.bashrc;
fi

set -e

# Run the container with shared X11
docker create\
  --net=host\
  --name=$2\
  -e SHELL\
  -e DISPLAY=$DISPLAY\
  -e DOCKER=1\
  --device=/dev/dri:/dev/dri \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
  -v $HOME/.Xauthority:/tmp/.Xauthority \
  -v $HOME/iarc7:$HOME/iarc7 \
  -e XAUTHORITY=/tmp/.Xauthority \
  -it\
  $1
