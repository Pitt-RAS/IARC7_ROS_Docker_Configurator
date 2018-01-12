## IARC7 ROS Docker Configurator

Run ROS Kinetic / Ubuntu Xenial within Docker on any platform with a shared
username, home directory, and X11.

This enables you to build and run a persistent ROS Kinetic workspace as long as
you can run Docker images.

For more info on Docker see here: https://docs.docker.com/engine/installation/linux/ubuntulinux/

### Prerequisites
This script uses the IARC7 ROS image from amiller27/iarc7-base.
If you don't have docker, be sure to install it in the way that your system allows. Check out the docs here: https://docs.docker.com/engine/installation/

Docker initially needs to run as root, if you are not added to the docker group
Run the following to add your user to the docker group
```
# usermod -a -G docker $USER
```
Then either logout and log back in, or run
```
# newgrp docker
```
This adds your user to the docker group for your current shell (You need to do
this for every new terminal emulator unitl you reboot or logout)

### Pull base image
Pull the base iarc7 image from Docker Hub into your system.
```
# docker pull amiller27/iarc7-base
```

### Build
This will create the image with your user/group ID and home directory.
```
./build.sh iarc7-yourusername
```

### Create
Next you need to create a container from the image. The image shares it's  network interface with the host.
```
./create.sh iarc7-yourusername iarc7_yourusername_month_date_year
```

### Run
To start the container run:
```
docker start iarc7_yourusername_month_date_year
```

To open a shell inside the container use:
```
docker exec -it iarc7_yourusername_month_date_year /bin/bash
```

You probably want to add the below lines to your .bashrc to make it easer to get into your  iarc7 container. The aliases allow you to automatically enter the docker container (it will be started if it isn't already running). You can also stop the docker container.
```
iarc7_name="iarc7_yourusername_month_date_year"

alias iarc7='[[ $(docker ps -f "name=$iarc7_name" --format '{{.Names}}') == $iarc7_name ]] || docker start $iarc7_name && \
             docker exec -it $iarc7_name /bin/bash'
alias iarc7_stop='docker stop $iarc7_name'
```

At this point you should following the instructions in iarc7_common for setting up a workspace: https://github.com/Pitt-RAS/iarc7_common/wiki/Installation

### FAQ

Q: I can't run any ROS commands (rosrun, roslaunch, catkin make)

A: Run
```
source ~/iarc7/devel/setup.bash
```
After you have the ~/iarc7 directory set up.

Q: Why is only ~/iarc7  mounted in the image? I want my whole home directory mounted!

A: We only mount ~/iarc7 to better seperate the user's $HOME and the image's $HOME
If you want to mount your whole home directory, edit create.sh

```
-v $HOME/iarc7:$HOME/iarc7 \
```
to
```
 -v $HOME/:$HOME/\
 ```
