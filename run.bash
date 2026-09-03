#!/bin/bash

# X サーバーのアクセス許可を開放
xhost +local:root

# DISPLAY 環境変数をエクスポート
export DISPLAY=$DISPLAY

# Docker コンテナ名・イメージ
IMAGE_NAME="docker_naxtage"
CONTAINER_NAME="ros_naxtage"

# ホームディレクトリの ROS ワークスペースをマウント
HOST_WS="$HOME/melodic_ws"
CONTAINER_WS="/home/$USER/melodic_ws"

# USB やジョイスティックなどデバイスマッピング
USB_DEVICE="/dev/ttyUSB0"
JS_DEVICE="/dev/input/js0"

# Docker run コマンド
docker run --rm -it \
--name "$CONTAINER_NAME" \
--privileged \
--net=host \
--ipc=host \
-e ROS_DOMAIN_ID=20 \
-e RMW_IMPLEMENTATION=rmw_fastrtps_cpp \
-e ROS_LOCALHOST_ONLY=0 \
-e DOCKER_USER_NAME="$(id -un)" \
-e DOCKER_USER_ID="$(id -u)" \
-e DOCKER_USER_GROUP_NAME="$(id -gn)" \
-e DOCKER_USER_GROUP_ID="$(id -g)" \
-v "$HOME/.Xauthority:/home/$(id -un)/.Xauthority:rw" \
-e XAUTHORITY="/home/$(id -un)/.Xauthority" \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY="unix$DISPLAY" \
-v /dev/snd:/dev/snd \
-e AUDIODEV="hw:Device,0" \
-v /dev:/dev \
-v "$HOST_WS:$CONTAINER_WS" \
--device="$USB_DEVICE:$USB_DEVICE" \
--device="$JS_DEVICE:$JS_DEVICE" \
"$IMAGE_NAME"
