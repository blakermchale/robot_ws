if [ -f ${WORKSPACE}/install/setup.bash ]; then
	source ${WORKSPACE}/install/setup.bash;
else
	if [ -f /opt/ros/${ROS_DISTRO}/setup.bash ]; then
		source /opt/ros/${ROS_DISTRO}/setup.bash;
	fi;
fi

export ROBOT_WS=$WORKSPACE
export PX4_AUTOPILOT=$WORKSPACE/src/PX4-Autopilot

source /usr/share/colcon_cd/function/colcon_cd.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# Convenience commands
alias killws='killall5 -9 gzserver gzclient _ros2_daemon micrortps_agent px4 ros2 darknet_ros python3 ruby; tmux kill-server'
tmuxstart () {
    tmux_proj=$1
    if [ -z "$1" ]
    then
        tmux_proj="$_ws/tmux_sim.yml"
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

# source /usr/share/gazebo/setup.sh
