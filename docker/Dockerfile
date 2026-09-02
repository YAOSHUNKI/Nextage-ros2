FROM ubuntu:18.04

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y \
	sudo git jstest-gtk wget tar curl unzip vim xvfb software-properties-common gedit htop build-essential net-tools bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*


#####################################################
# Install python packages
#####################################################
RUN apt-get update && apt-get install -y \
	python3-pip \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip

COPY ./pip/requirements.txt requirements.txt
RUN pip3 install -r requirements.txt


#####################################################
# ROS
#####################################################
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt-get update && apt-get install -y \
	ros-melodic-desktop-full \ 
	ros-melodic-gazebo* \ 
	ros-melodic-joy ros-melodic-joy-teleop* \
	ros-melodic-image-view ros-melodic-cv-camera && \
	apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
RUN echo "export ROS_HOSTNAME=localhost" >> /root/.bashrc
RUN echo "export ROS_IP=localhost" >> /root/.bashrc
# RUN echo "export ROS_HOSTNAME=192.168.11.2" >> /root/.bashrc
# RUN echo "export ROS_IP=192.168.11.2" >> /root/.bashrc
# RUN echo "export ROS_MASTER_URI=http://192.168.11.2:11311" >> /root/.bashrc
RUN 
#####################################################
# NEXTAGE
#####################################################
RUN apt-get update && apt-get install -y \
	ros-melodic-joint* ros-melodic-joint-state-controller ros-melodic-effort-controllers ros-melodic-position-controllers ros-melodic-ros-control ros-melodic-ros-controllers \
	ros-melodic-rtmros-hironx ros-melodic-rtmros-nextage && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:mattrose/terminator
RUN apt-get update && apt-get install -y \
	terminator  \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install pyquaternion scipy 
RUN apt-get update && apt-get install -y \
	python-yaml && \
	apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install pyyaml rospkg

RUN curl -kL https://bootstrap.pypa.io/pip/2.7/get-pip.py | python
RUN pip2 install pyquaternion scipy==1.2.0
RUN apt-get update && apt-get install -y \
	ros-melodic-moveit-visual* ros-melodic-fake-joint* && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	iputils-ping && \
	apt-get clean && rm -rf /var/lib/apt/lists/*


#####################################################
# Run scripts (commands)
#####################################################



### terminator window settings
COPY ./assets/config /

### user group settings
COPY ./assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]
# ENTRYPOINT ["/entrypoint_setup.sh"] /

# Run terminator
CMD ["terminator"]
