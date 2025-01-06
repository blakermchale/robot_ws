#!/bin/bash
_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

( # start subshell
_cmake_args=""
case $ROBOT_TYPE in
    *)
    case $@ in
        "")
            echo "Adding simulation steps..."
            # Build PX4
            # cd $_ws/src/PX4-Autopilot \
            # && DONT_RUN=1 make px4_sitl gazebo \
            # DONT_RUN=1 make px4_sitl ign_gazebo && \
            cd $_ws
            skipped_pkgs="px4 Darknet airsim_ros robot_behavior_tree darknet_ros"
        ;;
    esac
    ;;&
    darknet)
        echo "Adding darknet steps..."
        skipped_pkgs="px4 airsim_ros"
        _cmake_args+=" -DDARKNET_CUDA=Off"
    ;;
    darknet-cuda)
        echo "Adding darknet with CUDA..."
        skipped_pkgs="px4 airsim_ros"
    ;;
esac

# Check if AirSim is set and stack this workspace on top of it
if [[ -z "${AirSimPath}" ]]; then
  echo "AirSimPath is undefined not stacking on top"
else
  source $AirSimPath/ros2/install/setup.bash
fi

# TODO: add support for building with --verbose or -v arg, this would add `--event-handlers console_cohesion+` to the end of colcon build
# Build ROS2 packages
# _cmake_args+=" -DCMAKE_BUILD_TYPE=Release"
if [ -z "$1" ]; then
    _cmake_args+=" -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=On"
    colcon build --merge-install --symlink-install --cmake-args $_cmake_args -Wall -Wextra -Wpedantic --packages-skip $skipped_pkgs
    # colcon build --symlink-install --cmake-args $_cmake_args --packages-skip $skipped_pkgs
else
    _cmake_args+=" -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=On"
    colcon build --merge-install --symlink-install --cmake-args $_cmake_args -Wall -Wextra -Wpedantic --packages-skip $skipped_pkgs --packages-select $1
fi

find_package () {
    _package=$1
    cd $_ws/scripts/docs_help && \
    _path=$(python -c 'from modify_launch_rst import find_package; print(find_package('\"$_ws/src\"', '\"$_package\"'))')
    echo $_path
}
# Fix symlink for python3 files venv
var="#\!\/usr\/bin\/env python3"
fix_python_install() {
    package=$1
    for filename in $_ws/install/lib/$package/*; do
        sed -i "1s/.*/$var/" $filename
    done
    # Replace copied config files with symlinks
    pkg_path=$(find_package $package)
    for filename in $_ws/install/share/$package/config/*; do
        base=$(basename $filename)
        if [ "$base" = "*" ]; then
            echo "$package has no config folder, not symlinking"
        else
            cd $(dirname $filename) && \
            ln -f -s $pkg_path/config/$base $base
        fi
    done
    # Replace copied launch files with symlinks
    for filename in $_ws/install/share/$package/launch/*; do
        base=$(basename $filename)
        if [ "$base" = "*" ]; then
            echo "$package has no launch folder, not symlinking"
        else
            cd $(dirname $filename) && \
            ln -f -s $pkg_path/launch/$base $base
        fi
    done
}

fix_python_install robot_control
fix_python_install robot_bringup
fix_python_install cv_ros
fix_python_install robot_command
) # end subshell

bash
