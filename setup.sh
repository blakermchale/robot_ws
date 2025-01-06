#!/bin/bash
_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"
# Useful environmental variables
export ROBOT_WS=$_ws
export ROBOT_VENV=$HOME/.venv/robot
export PX4_AUTOPILOT=$_ws/src/PX4-Autopilot
# Add venv to path for packages to be recognized
# https://answers.ros.org/question/371083/how-to-use-python-virtual-environments-with-ros2/
export PYTHONPATH=$PYTHONPATH:$HOME/.venv/robot/lib/python3.8/site-packages

# Change DDS implementation
# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp  # rmw_fastrtps_cpp, rmw_fastrtps_dynamic_cpp, rmw_cyclonedds_cpp, rmw_connextdds

# Python virtual environment setup
source $ROBOT_VENV/bin/activate

# ROS package setup
source $_ws/install/setup.bash

# Nice colcon commands for switching to packages
source /usr/share/colcon_cd/function/colcon_cd.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
# export _colcon_cd_root=$_ws  # set root of colcon cd to this workspace

# Convenience commands
alias killws='killall5 -9 gzserver gzclient _ros2_daemon micrortps_agent px4 ros2 darknet_ros python3 ruby; tmux kill-server'
tmuxstart () {
    tmux_proj=$1
    if [ -z "$1" ]
    then
        tmux_proj="$_ws/tmux_sim.yaml"
    fi
    tmuxinator debug -p $tmux_proj > /tmp/tmux_robot_ws.sh
    chmod +x /tmp/tmux_robot_ws.sh
    sed -i '/^.*tmux .* send-keys .*/i sleep 0.5' /tmp/tmux_robot_ws.sh # need to add wait so terminals get time to start up
    /tmp/tmux_robot_ws.sh
}

# ROS variables, adds color to logging
export RCUTILS_COLORIZED_OUTPUT=1
# export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})"
export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity}][{function_name}():{line_number}]: {message}"

# Gazebo setup
# source /usr/share/gazebo/setup.sh
