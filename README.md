## IARC7 ROS Docker Configurator

Run ROS Kinetic / Ubuntu Xenial within Docker on any platform with a shared
username, home directory, and X11.

This enables you to build and run a persistent ROS Kinetic workspace as long as
you can run Docker images.

For more info on Docker see here: https://docs.docker.com/engine/installation/linux/ubuntulinux/

### How to use
This script uses the IARC7 ROS image from amiller27/iarc7-base.
If you don't have docker, be sure to install it in the way that your system allows.
For Debian based systems:
```
sudo apt install docker.io
```

This will pull the image from Docker Hub into your system.

```
sudo docker pull amiller27/iarc7-base
```
Docker initially needs to run as root, if you are not added to the docker group
Run the following to add your user to the docker group
```
usermod -a -G docker $USER
```
Then either logout and log back in, or run
```
newgrp docker
```
This adds your user to the docker group for your current shell (You need to do
this for every new terminal emulator unitl you reboot or logout)

This will build a new docker image from iarc7-base.
```
.\build.sh NEW_IMAGE_NAME
```
This will create a new container from the image
```
.\create.sh NEW_IMAGE_NAME NEW_CONTAINER_NAME
```
To start the container run:
```
docker start NEW_CONTAINER_NAME
```
To run the container interactively use:
```
docker exec -it NEW_CONTAINER_NAME /bin/bash
```
Afterword you should have a mostly complete ROS installation through docker,
though if you don't have IARC7 common cloned, you should follow those directions
next.
### Build

This will create the image with your user/group ID and home directory.

```
./build.sh IMAGE_NAME
```

### Create

This will create the docker container.

```
./create.sh IMAGE_NAME CONTAINER_NAME
```

The image shares it's  network interface with the host.

### FAQ
I can't run any ROS commands (rosrun, roslaunch, catkin make)
Run
```
source ~/iarc7/devel/setup.bash
```
After you have the ~/iarc7 directory set up.
