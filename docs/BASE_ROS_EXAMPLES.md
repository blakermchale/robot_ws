# Base ROS Examples
## Nav2 SLAM and BT Navigator
Install:
```bash
sudo apt install ros-foxy-nav2-bringup ros-foxy-turtlebot3 ros-foxy-turtlebot3-simulations
```
Run (separate terminals):
```bash
export TURTLEBOT3_MODEL=waffle
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```
```bash
ros2 launch nav2_bringup navigation_launch.py
```
```bash
ros2 launch slam_toolbox online_async_launch.py
```
```bash
ros2 topic pub /goal_pose geometry_msgs/PoseStamped "{header: {stamp: {sec: 0}, frame_id: 'map'}, pose: {position: {x: 0.2, y: 0.0, z: 0.0}, orientation: {w: 1.0}}}"
```
