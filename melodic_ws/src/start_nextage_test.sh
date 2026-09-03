#!/bin/bash

source /opt/ros/melodic/setup.bash
source "$(dirname "$(readlink -f "$0")")/../devel/setup.bash"

echo "Start Moveit"
roslaunch nextage_fillie_open_moveit_config moveit_planning_execution.launch & 
sleep 5

echo "start program"
roslaunch tork_moveit_tutorial position.launch &
sleep 5

# 終了防止（無限待機）
tail -f /dev/null
