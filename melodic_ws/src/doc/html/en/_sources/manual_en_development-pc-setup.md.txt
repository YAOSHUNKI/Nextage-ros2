## Setting up the development PC

When installing a new ubuntu PC, configure the PCs as follows.

### Installing from the Debian Binary Package

Install the software from the Debian binary package.

#### Installing the ROS and HIRO Software

Install ROS Melodic and HIRO packages.
Check the ROS Wiki, ([http://wiki.ros.org/melodic/Installation/Ubuntu#Ubuntu_install_of_ROS_Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu#Ubuntu_install_of_ROS_Melodic)) and install ROS. 
Next, run the following command in a terminal to install the HIRO package.

```
$ sudo apt install -y ros-melodic-rtmros-hironx
```

Once the installation is done, load the setup.bash and configure the ROS environments.

```
$ source /opt/ros/melodic/setup.bash
```

This is required every time you start up new terminals and use the ROS.
It is useful to automatically run the setup.bash when you start up the terminals and make it ROS by adding settings to the bashrc files as follow:
```
$ echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
```

- Note: **If the command `>>` is set to `>`, the setting in the bashrc that originally existed disappears.**

#### Installing NEXTAGE OPEN Software Only

If the ROS Melodic is already installed and only the NEXTAGE OPEN software needs to be installed, do only the following line:

```
$ sudo apt-get update && sudo apt-get install ros-melodic-rtmros-hironx
```

### Network settings
The IP address of the controller is 192.168.128.10. Change the IP address of the development PC to an appropriate value.

#### Host name setting (optional)

The default NEXTAGE OPEN software uses the hostname of the QNX computer for communication.
It is useful to set the host name on the operating system.

- Add the following line to `/ etc/hosts`.

```
# For accessing QNX for NEXTAGE Open
192.168.128.10 nextage
```

  - The IP address may differ from the above depending on the user's environment.
  - Enter `ping` and check to return from the nextage.
  - You do not need to change the above settings to use the manikin.
  - Except when you are using a network application that uses the `192.168.128.x` segment,
This setting is not detrimental to the use of the network.

- To avoid the https://github.com/start-jsk/rtmros_hironx/issues/33 of known OpenRTM problems,
make sure that `eth0` is used for networking.

### Workspace setup
In the setup procedures below,  `catkin_ws` (catkin workspace)  is used as the workspace name,
but any other names and folder names are also acceptable.
Here, rtmros_nextage_fillie_open.tar.bz2 is the ros package provided by Kawada Robotics.  
Please download rtmros_nextage_fillie_open.tar.bz2 from support site.
Place it at Home directory ( `~/` ) and execute following procedures.

```
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws/src
$ catkin_init_workspace
$ tar jxvf ~/rtmros_nextage_fillie_open.tar.bz2 -C ~/catkin_ws/src
$ cd ~/catkin_ws
$ catkin_make
$ source ~/catkin_ws/devel/setup.bash
```

If you do not want to run `source-/catkin_ws/devel/setup.bash` every time in terminals,
set it to.bashrc.

```
$ echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
```

- Note: **If the command `>>` is set to `>`, the setting in the bashrc that originally existed disappears.**

### DiagnosisUI setup
Download DiagnosisUI from the support site, place it in your home directory ( ~/ ) and follow the steps below.

```
$ chmod 744 DiagnosisUI
$ sudo apt-get install -y libqt4-dev
```

If you want to use the desktop shortcut for DiagnosisUI, download it from the support site, place it on your desktop, and perform the following steps.

```
$ chmod 744 Link¥ to¥ DiagnosisUI.desktop
```

### Camera Setup
Please install IDS Software Suite in order to use IDS uEye cameras. Please refer to the IDS website for installation instructions.  
  
Tested version : 4.95.2  
  
rtmros_nextage_fillie_open uses ueye_cam. Please follow the build procedure described in [https://wiki.ros.org/ueye_cam](https://wiki.ros.org/ueye_cam).
The operation of ueye_cam has been confirmed with the following versions.

Version confirmed to work : 1.0.17

Switching between versions can be performed with the following command.

```
$ cd ueye_cam
$ git checkout 1.0.17
```
<!-- EOF -->
