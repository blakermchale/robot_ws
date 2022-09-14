#!/bin/bash
_ws="$(readlink -m $(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)/..)"
sudo apt install \
    ros-humble-eigen-stl-containers ros-humble-diagnostic-updater \
    ros-humble-test-msgs ros-humble-bondcpp -y

$_ws/src/PX4-Autopilot/Tools/setup/ubuntu.sh