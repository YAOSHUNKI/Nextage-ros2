#!/usr/bin/env python
import moveit_commander
import rospy
from geometry_msgs.msg import Pose
from tf.transformations import quaternion_from_euler

def main():
    rospy.init_node("moveit_command_sender")

    botharms = moveit_commander.MoveGroupCommander("botharms")

    target_pose_r = Pose()
    target_pose_l = Pose()
    q = quaternion_from_euler(0, 0, 0)
    target_pose_r.position.x = 0.3
    target_pose_r.position.y = -0.4
    target_pose_r.position.z = 0.1
    target_pose_r.orientation.x = q[0]
    target_pose_r.orientation.y = q[1]
    target_pose_r.orientation.z = q[2]
    target_pose_r.orientation.w = q[3]
    target_pose_l.position.x = 0.3
    target_pose_l.position.y = 0.4
    target_pose_l.position.z = 0.1
    target_pose_l.orientation.x = q[0]
    target_pose_l.orientation.y = q[1]
    target_pose_l.orientation.z = q[2]
    target_pose_l.orientation.w = q[3]
    botharms.set_pose_target(target_pose_r, 'RARM_JOINT5_Link')
    botharms.set_pose_target(target_pose_l, 'LARM_JOINT5_Link')
    botharms.go()
    rospy.sleep(1)

    target_pose_r.position.x = 0.3
    target_pose_r.position.y =-0.2
    target_pose_r.position.z = 0.2
    target_pose_l.position.x = 0.3
    target_pose_l.position.y = 0.2
    target_pose_l.position.z = 0.2
    botharms.set_pose_target(target_pose_r, 'RARM_JOINT5_Link')
    botharms.set_pose_target(target_pose_l, 'LARM_JOINT5_Link')
    botharms.go()

if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
