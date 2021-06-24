#!/bin/bash
_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

_cmake_args=""
case $ROBOT_TYPE in
    *)
    case $@ in
        "")
            echo "Adding simulation steps..."
            # Build PX4
            cd $_ws/src/PX4-Autopilot
            DONT_RUN=1 make px4_sitl gazebo
            cd $_ws
            skipped_pkgs="px4"
        ;;
    esac
    ;;&
    darknet)
        echo "Adding darknet steps..."
        skipped_pkgs="px4"
        _cmake_args+=" -DDARKNET_CUDA=Off"
    ;;
    darknet-cuda)
        echo "Adding darknet with CUDA..."
        skipped_pkgs="px4"
    ;;
esac

# TODO: add support for building with --verbose or -v arg, this would add `--event-handlers console_cohesion+` to the end of colcon build
# Build ROS2 packages
cd $_ws
_cmake_args+=" -DCMAKE_BUILD_TYPE=Release"
if [ -z "$1" ]; then
    colcon build --symlink-install --cmake-args $_cmake_args --packages-skip $skipped_pkgs
else
    colcon build --symlink-install --cmake-args $_cmake_args --packages-skip $skipped_pkgs --packages-select $1
fi

# Fix symlink for python3 files venv
var="#\!\/usr\/bin\/env python3"
fix_python_install() {
    package=$1
    for filename in $_ws/install/$package/lib/$package/*; do
        sed -i "1s/.*/$var/" $filename
    done
}
fix_python_install robot_control

# source setup
cd $_ws
source setup.sh
