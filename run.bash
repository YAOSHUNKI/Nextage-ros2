#!/bin/bash
set -e

# ---- Resolve repository location from this script's path ----
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
cd "$SCRIPT_DIR"

HOST_MELODIC_WS="$SCRIPT_DIR/melodic_ws"
CONTAINER_MELODIC_WS="/ws/melodic_ws"

IMAGE_NAME="docker_nextage"
CONTAINER_NAME="ros_nextage"

# ---- Build the Docker image (only the first run actually rebuilds) ----
docker build -t "$IMAGE_NAME" .

# ---- Allow local X server access (ignore failure on headless hosts) ----
if command -v xhost >/dev/null 2>&1; then
    xhost +local:root >/dev/null || true
fi

# ---- Prepare a per-container Xauthority so we do not depend on ~/.Xauthority ownership ----
XAUTH="/tmp/.docker-nextage.xauth"
touch "$XAUTH"
chmod 644 "$XAUTH"
if command -v xauth >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
    xauth nlist "$DISPLAY" 2>/dev/null | sed -e 's/^..../ffff/' \
        | xauth -f "$XAUTH" nmerge - 2>/dev/null || true
fi

# ---- Only pass through devices that actually exist on this host ----
DEVICE_ARGS=()
for dev in /dev/ttyUSB0 /dev/input/js0; do
    if [ -e "$dev" ]; then
        DEVICE_ARGS+=(--device="$dev:$dev")
    else
        echo "[info] $dev not present, skipping"
    fi
done

# ---- Sound is optional too ----
SOUND_ARGS=()
if [ -d /dev/snd ]; then
    SOUND_ARGS+=(-v /dev/snd:/dev/snd -e AUDIODEV="hw:Device,0")
fi

# ---- Launch the container ----
# Inside the container we:
#   1. Source ROS1 (melodic) and ROS2 (dashing) setups.
#   2. Detect a missing OR stale devel/ (built on another machine) and rebuild.
#   3. Source the workspace and drop into an interactive shell.
docker run --rm -it \
    --name "$CONTAINER_NAME" \
    --privileged \
    --gpus all \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    --net=host \
    --ipc=host \
    -e ROS_DOMAIN_ID=20 \
    -e RMW_IMPLEMENTATION=rmw_fastrtps_cpp \
    -e ROS_LOCALHOST_ONLY=0 \
    -e DOCKER_USER_NAME="$(id -un)" \
    -e DOCKER_USER_ID="$(id -u)" \
    -e DOCKER_USER_GROUP_NAME="$(id -gn)" \
    -e DOCKER_USER_GROUP_ID="$(id -g)" \
    -v "$XAUTH:$XAUTH:rw" \
    -e XAUTHORITY="$XAUTH" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY="unix$DISPLAY" \
    "${SOUND_ARGS[@]}" \
    -v /dev:/dev \
    -v "$HOST_MELODIC_WS:$CONTAINER_MELODIC_WS" \
    "${DEVICE_ARGS[@]}" \
    -w /ws \
    --entrypoint /bin/bash \
    "$IMAGE_NAME" \
    -c '
        set -e
        source /opt/ros/melodic/setup.bash
        source /opt/ros/dashing/setup.bash
        source /ws/dashing_ws/install/setup.bash

        # ---- Decide whether melodic_ws needs to be (re)built ----
        NEED_BUILD=0
        EXPECTED_SRC=/ws/melodic_ws/src
        if [ ! -f /ws/melodic_ws/devel/setup.bash ]; then
            NEED_BUILD=1
        elif [ -f /ws/melodic_ws/devel/.catkin ] \
             && ! grep -Fxq "$EXPECTED_SRC" /ws/melodic_ws/devel/.catkin; then
            # devel/ was generated for a different workspace path (e.g. cloned from
            # another machine). Its embedded absolute paths are useless here.
            echo "[setup] Stale devel/ detected (built for a different path). Rebuilding."
            rm -rf /ws/melodic_ws/build /ws/melodic_ws/devel /ws/melodic_ws/logs
            NEED_BUILD=1
        fi

        if [ "$NEED_BUILD" = "1" ]; then
            echo "[setup] Building melodic_ws for the first time on this host..."

            # Fetch third-party sources if a rosinstall file is present.
            if [ -f /ws/melodic_ws/src/hironxo.rosinstall ] \
               && [ ! -d /ws/melodic_ws/src/rtmros_nextage_fillie_open ]; then
                apt-get update && apt-get install -y python-wstool || true
                (cd /ws/melodic_ws/src \
                    && (wstool init . hironxo.rosinstall || wstool update))
            fi

            # Best-effort dependency install; do not abort on missing keys.
            rosdep install --from-paths /ws/melodic_ws/src --ignore-src -r -y || true

            # catkin_make must run in a pristine ROS1-only env. Any leftover
            # ROS_DISTRO / CMAKE_PREFIX_PATH from ROS2 (dashing) breaks catkin
            # env-cache step. env -i wipes everything and we only source melodic.
            # We also nuke build/ so a half-built cache from a failed previous run
            # does not carry over stale paths.
            rm -rf /ws/melodic_ws/build /ws/melodic_ws/devel /ws/melodic_ws/logs
            env -i HOME="$HOME" TERM="$TERM" \
                PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
                bash -c "
                    set -e
                    source /opt/ros/melodic/setup.bash
                    cd /ws/melodic_ws
                    catkin_make
                "
        fi
        source /ws/melodic_ws/devel/setup.bash

        exec bash -i
    '
