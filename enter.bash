#!/bin/bash
# 起動済みの ros_nextage コンテナに追加ターミナルとして入る
# run.bash でコンテナを起動しておいてから、別ターミナルでこれを実行する

set -e

CONTAINER_NAME="ros_nextage"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "コンテナ ${CONTAINER_NAME} は起動していません。先に run.bash を実行してください。" >&2
    exit 1
fi

docker exec -it \
    -w /ws \
    "${CONTAINER_NAME}" \
    /bin/bash -c "source /opt/ros/melodic/setup.bash && \
source /opt/ros/dashing/setup.bash && \
source /ws/dashing_ws/install/setup.bash && \
[ -f /ws/melodic_ws/devel/setup.bash ] && source /ws/melodic_ws/devel/setup.bash; \
exec bash -i"
