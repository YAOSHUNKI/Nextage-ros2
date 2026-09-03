#!/bin/bash

source /opt/ros/melodic/setup.bash
source /home/melodic_ws/devel/setup.bash

echo "Start nextagea_ros_bridge_real.launch "
roslaunch nextage_fillie_open_ros_bridge nextage_fillie_open_ros_bridge_real.launch & 
sleep 10

echo "Servo On"
ipython -i `rospack find nextage_fillie_open_ros_bridge`/script/nextagea_automatic_start.py  -- --host nextage & 
sleep 5

echo "Start Moveit"
roslaunch nextage_fillie_open_moveit_config moveit_planning_execution.launch & 
sleep 5

# 終了防止（無限待機）
tail -f /dev/null
