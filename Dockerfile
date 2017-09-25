FROM amiller27/iarc7-base

# Arguments
ARG user
ARG uid
ARG home
ARG shell
ARG workspace

# Replace 1000 with your user / group id

# Basic Utilities
RUN apt-get -y update && apt-get install -y sudo zsh ranger ssh tree tmux

# nice stuff to have
#RUN apt-get install -y\
#rviz\

# The rest of ROS-desktop
#RUN apt-get install -y ros-kinetic-desktop-full

# Additional development tools
#RUN apt-get install -y x11-apps python-pip build-essential
#RUN pip install catkin_tools

# Make SSH available
EXPOSE 22

# Mount the user's home directory
#VOLUME "${home}"

# Clone user into docker image and set up X11 sharing 
RUN \
        mkdir -p /home/${user} && \
        echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
        echo "${user}:x:${uid}:" >> /etc/group && \
        echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
        chmod 0440 "/etc/sudoers.d/${user}"

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
#ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"
ENV PATH="/bin:/usr/bin:/usr/local/bin:${PATH}"
# Switch to the workspace
#WORKDIR ${workspace}
