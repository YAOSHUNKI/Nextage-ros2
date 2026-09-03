#!/usr/bin/env python
# -*- coding: utf-8 -*-
import math

def circle_eef(radius=0.1, eef='larm', step_degree=5, ccw=True, duration=0.1):
    '''
    Moves the designated eef point-by-point so that the trajectory as a whole draws a circle.

    Currently this only works on the Y-Z plane of *ARM_JOINT5 joint.
    And it's the most intuitive when eef maintains a "goInitial" pose where circle gets drawn on robot's X-Y plane
    (see the wiki for the robot's coordinate if you're confused http://wiki.ros.org/rtmros_nextage/Tutorials/Programming#HiroNXO_3D_model_coordination).

    Points on the circular trajectory is based on a standard equation https://en.wikipedia.org/wiki/Circle#Equations

    @param radius: (Unit: meter) Radius of the circle to be drawn.
    @param step_degree: Angle in degree each iteration increments.
    @param ccw: counter clock-wise.
    @param duration: Time for each iteration to be completed.
    '''
    goal_deg = GOAL_DEGREE = 360
    start_deg = 0
    if eef == 'larm':
        joint_eef = 'LARM_JOINT5'
    elif eef == 'rarm':
        joint_eef = 'RARM_JOINT5'
    eef_pos = robot.getCurrentPosition(joint_eef)
    eef_rpy = robot.getCurrentRPY(joint_eef)
    print('eef_pos={}'.format(eef_pos))
    X0 = eef_pos[0]
    Y0 = eef_pos[1]
    ORIGIN_x = X0
    ORIGIN_y = Y0 - radius
    print('ORIGIN_x={} ORIGIN_y={}'.format(ORIGIN_x, ORIGIN_y))
    i = 0
    for theta in range(start_deg, goal_deg, step_degree):
        if not ccw:
            theta = -theta
        x = ORIGIN_x + radius*math.sin(math.radians(theta))  # x-axis in robot's eef space is y in x-y graph
        y = ORIGIN_y + radius*math.cos(math.radians(theta))
        eef_pos[0] = x
        eef_pos[1] = y
        print('#{}th theta={} x={} y={} X0={} Y0={}'.format(i, theta, x, y, X0, Y0))
        robot.setTargetPose(eef, eef_pos, eef_rpy, duration)
        robot.waitInterpolation()
        i += 1




if __name__ == '__main__':
    circle_eef()
