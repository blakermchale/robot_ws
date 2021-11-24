#!/bin/bash
_ws="$(readlink -m $(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)/..)"
sudo apt install ros-galactic-mavlink ros-galactic-geographic-msgs libgeographic-dev ros-galactic-eigen-stl-containers ros-galactic-diagnostic-updater ros-galactic-behaviortree-cpp-v3 ros-galactic-test-msgs ros-galactic-bondcpp ros-galactic-ompl ros-galactic-xacro ros-galactic-gazebo-ros-pkgs ros-galactic-nav2-bt-navigator ros-galactic-mavros ros-galactic-image-transport-plugins -y
sudo apt install libignition-common3-graphics-dev -y
sudo apt install  python3-venv python-is-python3 python3-colcon-common-extensions -y
# Groot depndencies
sudo apt install qtbase5-dev libqt5svg5-dev libzmq3-dev libdw-dev -y
# Ignition
sudo apt install ros-galactic-ros-ign-gazebo ros-galactic-ros-ign-bridge -y

# sudo apt install python3-rosdep2
# rosdep update
# rosdep install -y -r -q --from-paths src --ignore-src --rosdistro galactic
$_ws/src/PX4-Autopilot/Tools/setup/ubuntu.sh