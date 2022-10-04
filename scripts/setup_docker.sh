#!/bin/bash
DIR="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

sudo apt-get update
if [[ $(grep Microsoft /proc/version) ]]; then

else
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker
fi
pip3 install json5

(cd $DIR/docker && python gen_devcontainer.py)
