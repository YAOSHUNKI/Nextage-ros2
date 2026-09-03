#!/usr/bin/env python
#########################################################################################
# @file     nextage_fillie_open_moveit_sample.py(derive from nextage_moveit_sample.py)  #
# @brief    Nextage Move it demo program                                                #
# @date     2015/05/26                                                                  #
# @author   Ryu Yamamoto                                                                #
#########################################################################################
import moveit_commander
import rospy
import geometry_msgs.msg

def main():
	rospy.init_node("moveit_command_sender")

	robot = moveit_commander.RobotCommander()
    
	print "=" * 10, " Robot Groups:"
	print robot.get_group_names()

	print "=" * 10, " Printing robot state"
	print robot.get_current_state()
	print "=" * 10 

	rarm = moveit_commander.MoveGroupCommander("right_arm")
	larm = moveit_commander.MoveGroupCommander("left_arm")

	print "=" * 15, " Right arm ", "=" * 15
	print "=" * 10, " Reference frame: %s" % rarm.get_planning_frame()
	print "=" * 10, " Reference frame: %s" % rarm.get_end_effector_link()
    
	print "=" * 15, " Left ight arm ", "=" * 15
	print "=" * 10, " Reference frame: %s" % larm.get_planning_frame()
	print "=" * 10, " Reference frame: %s" % larm.get_end_effector_link()

	#Right Arm Initial Pose
	rarm_initial_pose = rarm.get_current_pose().pose
	print "=" * 10, " Printing Right Hand initial pose: "
	print rarm_initial_pose

	#Light Arm Initial Pose
	larm_initial_pose = larm.get_current_pose().pose    
	print "=" * 10, " Printing Left Hand initial pose: "
	print larm_initial_pose

	target_pose_r = geometry_msgs.msg.Pose()
	target_pose_r.position.x = 0.3
	target_pose_r.position.y = -0.3
	target_pose_r.position.z = 0.1
	target_pose_r.orientation.x = 0
	target_pose_r.orientation.y = 0
	target_pose_r.orientation.z = 0
	target_pose_r.orientation.w = 1
	rarm.set_pose_target(target_pose_r)

	print "=" * 10," plan1 ..."
	rarm.go()
	rospy.sleep(1)
	
	target_pose_l = [
		target_pose_r.position.x,
		-target_pose_r.position.y,
		target_pose_r.position.z,
		target_pose_r.orientation.x,
		target_pose_r.orientation.y,
		target_pose_r.orientation.z,
		target_pose_r.orientation.w
	]
	larm.set_pose_target(target_pose_l)

	print "=" * 10," plan2 ..."
	larm.go()
	rospy.sleep(1)
	
	#Clear pose
	rarm.clear_pose_targets()

	#Right Hand
	target_pose_r.position.x = 0.2
	target_pose_r.position.y = 0
	target_pose_r.position.z = 0.3
	target_pose_r.orientation.x = 0
	target_pose_r.orientation.y = 0
	target_pose_r.orientation.z = 0
	target_pose_r.orientation.w = 1
	rarm.set_pose_target(target_pose_r)
	
	print "=" * 10, " plan3..."
	rarm.go()
	rospy.sleep(1)

	print "=" * 10,"Initial pose ..."
	rarm.set_pose_target(rarm_initial_pose)
	larm.set_pose_target(larm_initial_pose)
	rarm.go()
	larm.go()
	rospy.sleep(2)
	
if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
