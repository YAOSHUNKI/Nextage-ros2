# rm:         コンテナ終了時に自動的にコンテナを削除
# it:         -i + -t: 標準入力とTerminalをAttachする
# gpus:       all, または 0, 1, 2
# privileged: ホストと同じレベルでのアクセス許可
# net=host:   ホストとネットワーク名前空間を共有
# ipc=host:   ホストとメモリ共有

xhost +local:root
export DISPLAY=$DISPLAY

docker run --rm -it --privileged --net=host --ipc=host \
-e DOCKER_USER_NAME=$(id -un) \
-e DOCKER_USER_ID=$(id -u) \
-e DOCKER_USER_GROUP_NAME=$(id -gn) \
-e DOCKER_USER_GROUP_ID=$(id -g) \
-v $HOME/.Xauthority:/home/$(id -un)/.Xauthority -e XAUTHORITY=/home/$(id -un)/.Xauthority \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
-v /dev/snd:/dev/snd -e AUDIODEV="hw:Device, 0" \
-v /dev:/dev \
-v /home/$USER/melodic_ws:/home/$USER/melodic_ws \
--device=/dev/ttyUSB0:/dev/ttyUSB0 \
--device=/dev/input/js0:/dev/input/js0 \
docker_ros1_ubuntu18_nongpu

