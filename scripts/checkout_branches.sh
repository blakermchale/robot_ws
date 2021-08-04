#!/bin/bash
_ws="$(readlink -m $(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)/..)"

switch_to_branch () {
    _path=$1
    _branch=$2
    cd $_path
    if [ $? -ne 0 ]; then
        return
    fi
    echo "Checking out $_path with branch $_branch"
    git checkout $_branch
    git pull
}

git submodule update --init --recursive

# Make sure this repo is on master and updated
switch_to_branch $_ws main

_paths=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
_branches=$(git config --file .gitmodules --get-regexp branch | awk '{ print $2 }')
_branches=($_branches)
_i=0
for val in $_paths; do
    switch_to_branch "$_ws/$val" ${_branches[$_i]}
    let _i=_i+1
done
