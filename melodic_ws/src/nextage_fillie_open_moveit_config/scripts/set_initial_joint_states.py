#!/usr/bin/env python
# set_initial_joint_states.py
# Publishes a single latched JointState to /joint_states so MoveIt sees a safe start pose.

import rospy
from sensor_msgs.msg import JointState
import time

def main():
    rospy.init_node("set_initial_joint_states", anonymous=True)

    pub = rospy.Publisher("/joint_states", JointState, queue_size=1, latch=True)
    rospy.sleep(0.5)  # allow publisher to register

    # ----- IMPORTANT -----
    # Replace the names and positions below with the real joint names used by your Nextage model.
    # You can inspect actual names with: rostopic echo /joint_states -n1
    joint_names = [
        "WAIST_JOINT", 
        "RARM_JOINT1", "RARM_JOINT2", "RARM_JOINT3", "RARM_JOINT4", "RARM_JOINT5", "RARM_JOINT6",
        "LARM_JOINT1", "LARM_JOINT2", "LARM_JOINT3", "LARM_JOINT4", "LARM_JOINT5", "LARM_JOINT6",
        "HEAD_JOINT1", "HEAD_JOINT2"
    ]

    # Example safe pose: small offsets to ensure arms are away from waist.
    # Tune these radian values so that WAIST and RARM_JOINT5_Link are not colliding.
    joint_positions = [
        0.0,        # WAIST_JOINT
        0.3, -0.5, 0.0, 1.0, 0.2, 0.0,  # Right arm (example)
        -0.3, -0.5, 0.0, 1.0, -0.2, 0.0, # Left arm (example)
        0.0, 0.0   # Head joints
    ]

    # Trim or expand lists to match actual robot joints
    if len(joint_names) != len(joint_positions):
        rospy.logwarn("joint_names and joint_positions length mismatch; truncating/padding with zeros.")
        # align lengths
        L = min(len(joint_names), len(joint_positions))
        joint_names = joint_names[:L]
        joint_positions = joint_positions[:L]

    js = JointState()
    js.header.stamp = rospy.Time.now()
    js.name = joint_names
    js.position = joint_positions

    rospy.loginfo("Publishing initial JointState (latched) for MoveIt start state...")
    pub.publish(js)

    # keep node alive briefly so latched message is available to late subscribers
    time.sleep(1.0)
    rospy.loginfo("Initial JointState published; exiting.")
    # exit, publisher is latched so message remains
    return

if __name__ == "__main__":
    try:
        main()
    except rospy.ROSInterruptException:
        pass
