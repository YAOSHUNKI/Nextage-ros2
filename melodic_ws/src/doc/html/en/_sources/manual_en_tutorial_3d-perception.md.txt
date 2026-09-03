# Tutorial: Three-Dimensional Recognition

## Robot camera settings

### NEXTAGE Fillie OPEN cameras

NEXTAGE Fillie OPEN  (not HIRO) can be equipped with a total of 4 IDS uEye cameras,
2 on the head and optional 1 on each of the left and right hands.
The operation of these cameras is done in the ueye_cam package, which is basically
which is summarized below:

- nextage_fillie_open_ros_bridge/launch/nextage_fillie_open_ueye_stereo.launch
- nextage_fillie_open_ros_bridge/launch/hands_ueye.launch  

 <!---->

Note: About HIRO Cameras
- The content described in this section does not relate to Cameras installed on HIRO.
- How HIRO Cameras operate may differ from what is described in this section.

### User-Specific Cameras

Cameras other than those available as options can also be used if they have a ROS driver.  
Cameras with ROS drivers can be identified from the following destinations:

- Sensors/Cameras - ROS Wiki
  - [http://wiki.ros.org/Sensors/Cameras](http://wiki.ros.org/Sensors/Cameras)
  - Note: It does not cover all information because It is updated manually.

Some users use Kinect and Xtion cameras on robotic heads.
In such cases, if collisions are to be determined by checking tf or by MoveIt! ,
You need to build 3D models for cameras and update robotic models.

### Head camera settings

#### Running the uEye Camera Node

Make sure that the robot head camera is installed on the head.
Run the stereo camera node.

```
$ source ~/<your_ueye_cam_ws>/devel/setup.bash
$ roslaunch nextage_fillie_open_ros_bridge nextage_fillie_open_ueye_stereo.launch
```

※ The execution of `$ source ~/<your_ueye_cam_ws>/devel/setup.bash` can be omitted if set in .bashrc in advance.

Since this node uses the ueye_cam package,
You can subscribe to video topics as follows.

```
$ rostopic echo left/image_raw
$ rostopic echo right/image_raw
```

Videos can be viewed using GUI tools such as rqt_image_view.

#### Calibration of the stereo camera

Before using a stereo camera, calibration is necessary.

- How to Calibrate a Stereo Camera - ROS Wiki
  - [http://wiki.ros.org/camera_calibration/Tutorials/StereoCalibration](http://wiki.ros.org/camera_calibration/Tutorials/StereoCalibration)

Use the following command to calibrate the stereo camera.

```
$ rosrun camera_calibration cameracalibrator.py --size 4x6 --square 0.024 --approximate=0.1 --camera_name=stereo_frame right:=/right/image_raw left:=/left/image_raw right_camera:=/right left_camera:=/left
```

Save the calibration results in \<your home directory>/.ros/ camera_info.
Keep this data intact.

### Hand-Camera Settings <!--todo not tested-->

Use the following command to operate the two cameras on the left and right hands.

```
$ source ~/<your_ueye_cam_ws>/devel/setup.bash
$ roslaunch nextage_fillie_open_ros_bridge hands_ueye.launch
```

Images from the hand camera can be subscribed to according to the following topics:

```
$ rostopic echo /left_hand_ueye/image_raw   (left)
$ rostopic echo /right_hand_ueye/image_raw  (right)
```

### Camera settings
You can use rqt_reconfigure to change camera settings.

```
$ rosrun rqt_reconfigure rqt_reconfigure
```
![camera_setting](../images/nxo_images/camera_setting.png)

You can check the camera image using rqt_image_view.

```
$ rosrun rqt_image_view rqt_image_view
```


<!-- EOF -->
