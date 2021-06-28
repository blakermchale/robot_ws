# Linux profile for setting up this workspace and its packages in a gnome-terminal
# If ros2_profile is set use that
if [[ -z "${ROS2_PROFILE}" ]]; then
  source $HOME/.bashrc  # Assume ROS2 is setup in .bashrc
else
  source $ROS2_PROFILE  # ROS2 is setup in other location
fi
source /opt/ros/foxy/setup.bash

_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"
source $_ws/setup.sh
