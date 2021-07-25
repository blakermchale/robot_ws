#!/bin/bash
_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

git_pull () {
    echo "Pulling from $1..."
    cd $1
    git pull
}

# Make sure this repo is updated
git_pull $_ws

# Get all submodule paths for this repository
_paths=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
for val in $_paths; do
    git_pull "$_ws/$val"
    if [ "$val" = "src/PX4-Autopilot" ]; then
        git submodule sync
        git submodule update --init --recursive
    fi
done
