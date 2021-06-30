# Examples
## base simulator with `robot_control`
```bash
ros2 launch robot_control run_vehicles.launch.py
```
## `robot_behavior_tree` example
Run (separate terminals):
```bash
ros2 launch robot_behavior_tree runner.launch.py
```
```bash
ros2 action send_goal /drone_0/run_tree robot_control_interfaces/action/RunBT {}
```
