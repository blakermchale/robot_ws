# Run command control with 3 drones

```
tmuxstart ./examples/drone_trio/tmux_ignition.yaml
```

```
sweep_search drone_0,drone_1,drone_2 -3.0 0,0 30,-10 23,27 0,10 0,0
```

# Run rover

```
tmuxstart ./examples/rover/tmux_ignition.yaml
```
