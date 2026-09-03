#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Nextage Gazebo 動作デモ
別ターミナルで:
  1) roslaunch nextage_fillie_open_gazebo nextage_fillie_open_world.launch
  2) roslaunch nextage_fillie_open_moveit_config moveit_planning_execution.launch
が上がった状態で:
  rosrun ... あるいは:
  python /ws/melodic_ws/demo/nextage_gazebo_demo.py
"""
import sys, time, rospy, moveit_commander

def main():
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node("nextage_gazebo_demo", anonymous=True)

    both = moveit_commander.MoveGroupCommander("botharms")
    rarm = moveit_commander.MoveGroupCommander("right_arm")
    larm = moveit_commander.MoveGroupCommander("left_arm")
    head = moveit_commander.MoveGroupCommander("head")

    for mg in (both, rarm, larm, head):
        mg.set_max_velocity_scaling_factor(0.5)
        mg.set_max_acceleration_scaling_factor(0.5)
        mg.set_planning_time(5.0)

    rospy.loginfo("=> init_rtm")
    both.set_named_target("init_rtm")
    both.go(wait=True); time.sleep(0.5)

    rospy.loginfo("=> right arm 手を上げる")
    # RARM_JOINT0..5  肩pan, 肩tilt, 肘, 手首roll, 手首pitch, 手首yaw
    rarm.set_joint_value_target([0.0, -0.3, -1.4,  0.0, -0.7, 0.0])
    rarm.go(wait=True); time.sleep(0.5)

    rospy.loginfo("=> right arm 手を振る (3回)")
    for _ in range(3):
        rarm.set_joint_value_target([ 0.4, -0.3, -1.4, 0.0, -0.7, 0.0]); rarm.go(wait=True)
        rarm.set_joint_value_target([-0.4, -0.3, -1.4, 0.0, -0.7, 0.0]); rarm.go(wait=True)

    rospy.loginfo("=> left arm 上げる")
    larm.set_joint_value_target([0.0, -0.3, -1.4, 0.0, -0.7, 0.0])
    larm.go(wait=True); time.sleep(0.5)

    rospy.loginfo("=> head 首ふり")
    head.set_joint_value_target([ 0.6, 0.0]); head.go(wait=True)
    head.set_joint_value_target([-0.6, 0.0]); head.go(wait=True)
    head.set_joint_value_target([ 0.0, 0.3]); head.go(wait=True)
    head.set_joint_value_target([ 0.0, 0.0]); head.go(wait=True)

    rospy.loginfo("=> init_rtm に戻る")
    both.set_named_target("init_rtm")
    both.go(wait=True)

    rospy.loginfo("done.")
    moveit_commander.roscpp_shutdown()

if __name__ == "__main__":
    main()
