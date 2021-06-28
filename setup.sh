#!/bin/bash
_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"
# Useful environmental variables
export ROBOT_WS=$_ws
export ROBOT_VENV=$HOME/.venv/robot
export PX4_AUTOPILOT=$_ws/src/PX4-Autopilot

# Python virtual environment setup
source $ROBOT_VENV/bin/activate

# ROS package setup
source $_ws/install/setup.bash

# Nice colcon commands for switching to packages
source /usr/share/colcon_cd/function/colcon_cd.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
export _colcon_cd_root=$_ws  # set root of colcon cd to this workspace

# Convenience commands
alias killros2='killall -9 gzserver gzclient _ros2_daemon micrortps_agent px4'

# ROS variables, adds color to logging
export RCUTILS_COLORIZED_OUTPUT=1
# export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})"
export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity}][{function_name}():{line_number}]: {message}"

# Gazebo setup
source /usr/share/gazebo/setup.sh
source $_ws/src/PX4-Autopilot/Tools/setup_gazebo.bash $_ws/src/PX4-Autopilot/ $_ws/src/PX4-Autopilot/build/px4_sitl_default/ > /dev/null
