docker run --rm -it  -p 14556:14556/udp -p 14557:14557/udp --network=host --cap-add=SYS_PTRACE --volume=/tmp/.X11-unix:/tmp/.X11-unix --gpus all --volume=/home/bmchale/git/personal/robot_ws:/workspaces/robot_ws vsc-robot_ws-6b2db0992a2f4a02ddf37a65f16f2e9e:latest