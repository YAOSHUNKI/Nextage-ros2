FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# ==========================
# 基本パッケージ
# ==========================
RUN apt-get update && apt-get install -y \
    sudo git jstest-gtk wget tar curl unzip vim xvfb software-properties-common gedit htop \
    build-essential net-tools bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 \
    mercurial subversion \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ==========================
# Python3 & pip
# ==========================
RUN apt-get update && apt-get install -y python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip

COPY ./pip/requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# ===============================================
# MELDOIC（ROS1）
# ===============================================

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
     > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc \
     | sudo apt-key add -

RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full \
    ros-melodic-gazebo* \
    ros-melodic-joy ros-melodic-joy-teleop* \
    ros-melodic-image-view ros-melodic-cv-camera \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
RUN echo "export ROS_HOSTNAME=localhost" >> /root/.bashrc
RUN echo "export ROS_IP=localhost" >> /root/.bashrc

# ===============================================
# NEXTAGE
# ===============================================

RUN apt-get update && apt-get install -y \
    ros-melodic-joint* ros-melodic-joint-state-controller \
    ros-melodic-effort-controllers ros-melodic-position-controllers \
    ros-melodic-ros-control ros-melodic-ros-controllers \
    ros-melodic-rtmros-hironx ros-melodic-rtmros-nextage \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:mattrose/terminator
RUN apt-get update && apt-get install -y terminator \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install pyquaternion scipy
RUN apt-get update && apt-get install -y python-yaml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install pyyaml rospkg

RUN curl -kL https://bootstrap.pypa.io/pip/2.7/get-pip.py | python
RUN pip2 install pyquaternion scipy==1.2.0

RUN apt-get update && apt-get install -y \
    ros-melodic-moveit-visual* ros-melodic-fake-joint* \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y iputils-ping \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ===============================================
# Dashing（ROS2）
# ===============================================

RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release 

# ROS2 apt 
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt update

# Dashing
RUN apt-get update && apt-get install -y \
    ros-dashing-desktop \
    python3-colcon-common-extensions \
    python3-argcomplete
    
RUN echo "source /opt/ros/dashing/setup.bash" >> /root/.bashrc

# ===============================================
# ros1_bridge
# ===============================================
RUN mkdir -p /ros1_bridge_ws/src
WORKDIR /ros1_bridge_ws/src

RUN git clone -b dashing https://github.com/ros2/ros1_bridge.git

WORKDIR /ros1_bridge_ws
RUN bash -c " \
    source /opt/ros/melodic/setup.bash && \
    source /opt/ros/dashing/setup.bash && \
    colcon build \
      --symlink-install \
      --packages-select ros1_bridge \
      --cmake-force-configure \
      --cmake-args -DBUILD_TESTING=OFF \
"

RUN echo "source /ros1_bridge_ws/install/setup.bash" >> /root/.bashrc

# ===============================================
# RUN scripts
# ===============================================

COPY ./assets/config /
COPY ./assets/entrypoint_setup.sh /

RUN chmod +x /entrypoint_setup.sh
ENTRYPOINT ["/entrypoint_setup.sh"]

CMD ["terminator"]