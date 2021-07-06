# Examples
## base simulator with `robot_control`
```bash
ros2 launch robot_control run_vehicles.launch.py
```
## `robot_behavior_tree` example
Run (separate terminals):
```bash
ros2 launch robot_behavior_tree runner.launch.py namespace:=drone_0
```
```bash
ros2 action send_goal /drone_0/run_bt robot_control_interfaces/action/RunBT {}
```
## Groot example
1. Run `Groot`:
```bash
ros2 run groot Groot --mode monitor
```
2. Run behavior tree runner:
```bash
ros2 launch robot_behavior_tree runner.launch.py
```
3. Press `Connect` in the upper left of the GUI that pops up (assuming IP address and ports are default)
4. Run behavior tree action:
```bash
ros2 action send_goal /drone_0/run_tree robot_control_interfaces/action/RunBT {}
```
5. Watch Groot monitor tree!
