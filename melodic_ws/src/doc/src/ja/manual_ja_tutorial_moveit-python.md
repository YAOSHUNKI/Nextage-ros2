# チュートリアル: MoveIt! Python インタフェース

## MoveIt! Commander<!--MoveIt Commander-->

MoveIt! の動作計画などの機能は GUI（RViz）からの操作を提供しているだけではありません。
プログラミングインタフェースである MoveIt! Commander も提供されていますので、
プログラミング言語から MoveIt! の機能を利用してロボットを動かすこともできます。

## MoveIt! Python インタフェース使用環境<!--MoveIt Python Interfaces Usage Environments-->

MoveIt! の Python インタフェース MoveIt! Python Commander を使用するときの環境は次のようになっています。

- rtmros_hironx: バージョン 1.1.4 以降（ Hironx/NEXTAGE Fillie OPEN ）
- 推奨プログラミングインタフェース: `ROS_Client`（ RobotCommander から派生 ）
- RobotCommander は MoveIt! の Python プログラミングインタフェース

MoveIt! の Python インタフェースである moveit_commander パッケージが
Ubuntu コンピュータ上にない場合はインストールする必要があります。

```
$ sudo apt-get install ros-%YOUR_ROS_DISTRO%-moveit-commander
```

## MoveIt! Python インタフェースからのロボット操作<!--Robotics from MoveIt Python interfaces-->

### MoveIt! Python インタフェースの起動<!--Starting the MoveIt Python interfaces-->

#### rtm_ros_bridge の実行<!--Running rtm_ros_bridge-->

rtm_ros_bridge を実行します。

```
$ roslaunch nextage_fillie_open_ros_bridge nextage_fillie_open_ros_bridge_real.launch nameserver:=%HOSTNAME%
```

#### MoveIt! サーバの起動<!--Starting the MoveIt Servers-->

`ROS_Client` クラスをベースにしたプログラムを実行するためには、
その "クライアント" に対する "サーバ" として MoveIt! のノードが走っている必要があります。

MoveIt! を起動します。

```
$ roslaunch nextage_fillie_open_moveit_config moveit_planning_execution.launch
```


### Python での MoveIt! Commander を用いたロボット操作<!--Robotics with MoveIt Commander in Python-->

Python から MoveIt! Commander を利用しているサンプルプログラムで、
NEXTAGE Fillie OPENロボットをどのように動作させているのかを見てみます。

<!-- - [https://github.com/tork-a/rtmros_nextage/blob/indigo-devel/nextage_ros_bridge/script/nextage_moveit_sample.py](https://github.com/tork-a/rtmros_nextage/blob/indigo-devel/nextage_ros_bridge/script/nextage_moveit_sample.py) -->

- ~/catkin_ws/src/nextage_fillie_open_ros_bridge/script/nextage_fillie_open_moveit_sample.py

サンプルコード全体を下に記載します。その後に各行について何をしているのかを見てみます。

```python
1 #!/usr/bin/env python
2 #########################################################################################
3 # @file     nextage_fillie_open_moveit_sample.py(derive from nextage_moveit_sample.py)  #
4 # @brief    Nextage Move it demo program                                                #
5 # @author   Ryu Yamamoto                                                                #
6 # @date     2015/05/26                                                                  #
7 #########################################################################################
8 import moveit_commander
9 import rospy
10 import geometry_msgs.msg
11
12 def main():
13         rospy.init_node("moveit_command_sender")
14
15         robot = moveit_commander.RobotCommander()
16
17         print "=" * 10, " Robot Groups:"
18         print robot.get_group_names()
19
20         print "=" * 10, " Printing robot state"
21         print robot.get_current_state()
22         print "=" * 10
23
24         rarm = moveit_commander.MoveGroupCommander("right_arm")
25         larm = moveit_commander.MoveGroupCommander("left_arm")
26
27         print "=" * 15, " Right arm ", "=" * 15
28         print "=" * 10, " Reference frame: %s" % rarm.get_planning_frame()
29         print "=" * 10, " Reference frame: %s" % rarm.get_end_effector_link()
30
31         print "=" * 15, " Left ight arm ", "=" * 15
32         print "=" * 10, " Reference frame: %s" % larm.get_planning_frame()
33         print "=" * 10, " Reference frame: %s" % larm.get_end_effector_link()
34
35         #Right Arm Initial Pose
36         rarm_initial_pose = rarm.get_current_pose().pose
37         print "=" * 10, " Printing Right Hand initial pose: "
38         print rarm_initial_pose
39
40         #Light Arm Initial Pose
41         larm_initial_pose = larm.get_current_pose().pose
42         print "=" * 10, " Printing Left Hand initial pose: "
43         print larm_initial_pose
44
45         target_pose_r = geometry_msgs.msg.Pose()
46         target_pose_r.position.x = 0.3
47         target_pose_r.position.y = -0.3
48         target_pose_r.position.z = 0.1
49         target_pose_r.orientation.x = 0
50         target_pose_r.orientation.y = 0
51         target_pose_r.orientation.z = 0
52         target_pose_r.orientation.w = 1
53         rarm.set_pose_target(target_pose_r)
54
55         print "=" * 10," plan1 ..."
56         rarm.go()
57         rospy.sleep(1)
58
59         target_pose_l = [
60                 target_pose_r.position.x,
61                 -target_pose_r.position.y,
62                 target_pose_r.position.z,
63                 target_pose_r.orientation.x,
64                 target_pose_r.orientation.y,
65                 target_pose_r.orientation.z,
66                 target_pose_r.orientation.w
67         ]
68         larm.set_pose_target(target_pose_l)
69
70         print "=" * 10," plan2 ..."
71         larm.go()
72         rospy.sleep(1)
73
74         #Clear pose
75         rarm.clear_pose_targets()
76
77         #Right Hand
78         target_pose_r.position.x = 0.2
79         target_pose_r.position.y = 0
80         target_pose_r.position.z = 0.3
81         target_pose_r.orientation.x = 0
82         target_pose_r.orientation.y = 0
83         target_pose_r.orientation.z = 0
84         target_pose_r.orientation.w = 1
85         rarm.set_pose_target(target_pose_r)
86
87         print "=" * 10, " plan3..."
88         rarm.go()
89         rospy.sleep(1)
90
91         print "=" * 10,"Initial pose ..."
92         rarm.set_pose_target(rarm_initial_pose)
93         larm.set_pose_target(larm_initial_pose)
94         rarm.go()
95         larm.go()
96         rospy.sleep(2)
97
98 if __name__ == '__main__':
99     try:
100         main()
101     except rospy.ROSInterruptException:
102         pass
```

動作計画と実行を行う Python スクリプトの主要な部分は

1. エンドエフェクタのリンクの位置と姿勢をターゲットとして指定
2. ターゲットの姿勢まで動作させる

という手順になります。
また、そのための準備としてエンドエフェクタの姿勢などを取得しています。

Python スクリプトの各行を具体的に見ていきます。

MoveIt! の Python インタフェース は
`moveit_commander.MoveGroupCommander` で提供されます。

```python
import moveit_commander
import rospy
import geometry_msgs.msg
```

この Python スクリプトから `MoveGroupCommander` を使うために
`rospy.init_node()` を呼び出して ROS ノードを実行します。

```python
rospy.init_node("moveit_command_sender")
```

RobotCommander をインスタンス化します。

```python
robot = moveit_commander.RobotCommander()
```

ロボットの全ての Group の名前のリストを取得、表示します。

```python
print "=" * 10, " Robot Groups:"
print robot.get_group_names()
```

ロボット全体の状態を表示するとデバッグに役立ちます。

```python
print "=" * 10, " Printing robot state"
print robot.get_current_state()
```

現在のロボットの各腕の姿勢を取得します。

```python
rarm_current_pose = rarm.get_current_pose().pose
larm_current_pose = larm.get_current_pose().pose
```

初期姿勢オブジェクトに現在のロボットの各腕の姿勢を代入します。

```python
rarm_initial_pose = rarm.get_current_pose().pose
print "=" * 10, " Printing Right Hand initial pose: "
print rarm_initial_pose

larm_initial_pose = larm.get_current_pose().pose
print "=" * 10, " Printing Left Hand initial pose: "
print larm_initial_pose
```

動作計画を行いロボットを動作させます。

**Execution Plan 1**

```python
target_pose_r = geometry_msgs.msg.Pose()
target_pose_r.position.x = 0.4
target_pose_r.position.y = -0.33
target_pose_r.position.z = 0.121
target_pose_r.orientation.x = 0
target_pose_r.orientation.y = 0
target_pose_r.orientation.z = 0
target_pose_r.orientation.w = 1
rarm.set_pose_target(target_pose_r)

print "=" * 10," plan1 ..."
rarm.go()
rospy.sleep(1)
```

![MoveIt! Commander - Execute Plan 1](../images/nxo_images/Plan1.png)


**Execution Plan 2**

```python
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
```

![MoveIt! Commander - Execute Plan 2](../images/nxo_images/Plan2.png)


**Execution Plan 3**

```python
rarm.clear_pose_targets()

#Right Hand
target_pose_r.position.x = 0.4854
target_pose_r.position.y = -0.012751
target_pose_r.position.z = 0.29067
target_pose_r.orientation.x = 0.000045184
target_pose_r.orientation.y = 0.00005316
target_pose_r.orientation.z = 0.000022341
target_pose_r.orientation.w = 1
rarm.set_pose_target(target_pose_r)

print "=" * 10, " plan3..."
rarm.go()
rospy.sleep(1)
```

![MoveIt! Commander - Execute Plan 3](../images/nxo_images/Plan3.png)


**Go Initial**

```python
print "=" * 10,"Initial pose ..."
rarm.set_pose_target(rarm_initial_pose)
larm.set_pose_target(larm_initial_pose)
rarm.go()
larm.go()
rospy.sleep(2)
```

![MoveIt! Commander - Go Initial](../images/nxo_images/Initial.png)

<!-- 動画: "Nextage Move it! demo" [https://www.youtube.com/watch?v=heKEKg3I7cQ](https://www.youtube.com/watch?v=heKEKg3I7cQ) -->

また、MoveIt! を表示している RViz 上でもこれらの動作計画が表示されます。

実際にサンプルプログラムを実行して、
NEXTAGE OPEN ロボットが動作計画どおりに動いているかを見てみます。

- 注意: **ロボットが動きます。**

ターミナルから次のコマンドを実行してサンプルプログラムを実行します。

```
$ rosrun nextage_fillie_open_ros_bridge nextage_fillie_open_moveit_sample.py
```

MoveIt! Commander では更に様々なメソッドがありますので
ROS Wiki の moveit_commander のページを参照してください。

- ROS Wiki - moveit_commander
  - [http://wiki.ros.org/moveit_commander](http://wiki.ros.org/moveit_commander)


<!-- EOF -->
