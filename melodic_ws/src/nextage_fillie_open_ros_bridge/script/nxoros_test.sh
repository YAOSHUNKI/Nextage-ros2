#!/bin/bash
cd `dirname $0`


cnt=0
loop=1

#while [ $cnt -lt $loop ]
while :
do
    echo "little1 $cnt"
    cnt=`expr $cnt + 1`
    # rostopic pub /rarm_controller/command trajectory_msgs/JointTrajectory '{joint_names: ["RARM_JOINT0","RARM_JOINT1","RARM_JOINT2","RARM_JOINT3","RARM_JOINT4","RARM_JOINT5"], points: [{positions:[0,0,-1,0,0,0],velocities:[0],accelerations:[0],effort:[0],time_from_start: [1,0]}]}' -1
    rostopic pub /rarm_controller/command trajectory_msgs/JointTrajectory "header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs: 0
  frame_id: '/WAIST'
joint_names: ['RARM_JOINT0', 'RARM_JOINT1', 'RARM_JOINT2', 'RARM_JOINT3', 'RARM_JOINT4', 'RARM_JOINT5']
points: 
  - 
    positions: [0.2,-0.3,-1,0.2,-0.3,0.2]
    velocities: [0.0]
    accelerations: [0.0]
    effort: [0.0]
    time_from_start: 
      secs: 1
      nsecs: 0" --once &

    rostopic pub /larm_controller/command trajectory_msgs/JointTrajectory "header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs: 0
  frame_id: '/WAIST'
joint_names: ['LARM_JOINT0', 'LARM_JOINT1', 'LARM_JOINT2', 'LARM_JOINT3', 'LARM_JOINT4', 'LARM_JOINT5']
points: 
  - 
    positions: [-0.2,-0.3,-1,-0.2,-0.3,-0.2]
    velocities: [0.0]
    accelerations: [0.0]
    effort: [0.0]
    time_from_start: 
      secs: 1
      nsecs: 0" --once &

    rostopic pub /head_controller/command trajectory_msgs/JointTrajectory "header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs: 0
  frame_id: '/WAIST'
joint_names: ['HEAD_JOINT0', 'HEAD_JOINT1']
points: 
  - 
    positions: [-0.2, 0.3]
    velocities: [0.0]
    accelerations: [0.0]
    effort: [0.0]
    time_from_start: 
      secs: 1
      nsecs: 0" --once &
    
    rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'larm'"
    rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'rarm'" 

     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "rarm" [0,0,0,0,0,0] 1 &
     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "larm" [0,0,0,0,0,0] 1
     rosservice call /SequencePlayerServiceROSBridge/waitInterpolation # bug

     rostopic pub /torso_controller/command trajectory_msgs/JointTrajectory "header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs: 0
  frame_id: '/WAIST'
joint_names: ['CHEST_JOINT0']
points: 
  - 
    positions: [0.4]
    velocities: [0.0]
    accelerations: [0.0]
    effort: [0.0]
    time_from_start: 
      secs: 1
      nsecs: 0" --once &
     rosservice call /SequencePlayerServiceROSBridge/setTargetPose "rarm" [0.43,-0.05,0.021] [0,0,0] 1
     rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'rarm'"
     rosservice call /SequencePlayerServiceROSBridge/setTargetPose "rarm" [0.37,-0.23,0.021] [0,0,0] 1 &

     rostopic pub /torso_controller/command trajectory_msgs/JointTrajectory "header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs: 0
  frame_id: '/WAIST'
joint_names: ['CHEST_JOINT0']
points: 
  - 
    positions: [-0.2]
    velocities: [0.0]
    accelerations: [0.0]
    effort: [0.0]
    time_from_start: 
      secs: 1
      nsecs: 0" --once &

     
     rosservice call /SequencePlayerServiceROSBridge/setTargetPose "larm" [0.43,0.05,0.021] [0,0,0] 1
     rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'larm'" 
     rosservice call /SequencePlayerServiceROSBridge/setTargetPose "larm" [0.37,0.23,0.021] [0,0,0] 1 &
     
     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "torso" [0] 1 &
     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "head" [0,0] 1 &
     rosservice call /SequencePlayerServiceROSBridge/waitInterpolation

     rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'rarm'" 
     rosservice call /SequencePlayerServiceROSBridge/waitInterpolationOfGroup "gname: 'larm'" 

     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "rarm" [0,0,0,0,0,0] 1 &
     rosservice call /SequencePlayerServiceROSBridge/setJointAnglesOfGroup "larm" [0,0,0,0,0,0] 1
     rosservice call /ForwardKinematicsServiceROSBridge/getCurrentPose "linkname: 'RARM_JOINT5'"
     rosservice call /ForwardKinematicsServiceROSBridge/getReferencePose "linkname: 'RARM_JOINT5'"
      rosservice call /ForwardKinematicsServiceROSBridge/getCurrentPose "linkname: 'LARM_JOINT5'"
     rosservice call /ForwardKinematicsServiceROSBridge/getReferencePose "linkname: 'LARM_JOINT5'"
done

# "header:
#   seq: 0
#   stamp:
#     secs: 0
#     nsecs: 0
#   frame_id: ''
# joint_names:
# - ''
# points:
# - positions: [0]
#   velocities: [0]
#   accelerations: [0]
#   effort: [0]
#   time_from_start: {secs: 0, nsecs: 0}" 
