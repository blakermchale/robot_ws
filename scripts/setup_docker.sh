#!/bin/bash
# Setup file for linux docker regardless of WSL or native
DIR="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

sudo apt-get update
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    echo "on WSL"
else
    echo "on native linux"
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker
fi
sudo apt install python3 python3-pip -y
pip3 install json5
(cd $DIR/docker && python3 gen_devcontainer.py)
