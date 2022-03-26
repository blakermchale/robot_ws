#!/bin/bash
_ws="$(readlink -m $(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)/..)"
sudo apt install \
    ros-galactic-eigen-stl-containers ros-galactic-diagnostic-updater \
    ros-galactic-test-msgs ros-galactic-bondcpp -y

$_ws/src/PX4-Autopilot/Tools/setup/ubuntu.sh