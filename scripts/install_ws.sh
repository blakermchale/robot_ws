sudo apt install ros-galactic-mavlink ros-galactic-geographic-msgs libgeographic-dev ros-galactic-eigen-stl-containers ros-galactic-diagnostic-updater ros-galactic-behaviortree-cpp-v3 ros-galactic-test-msgs ros-foxy-galactic-bondcpp ros-galactic-ompl ros-galactic-xacro -y
sudo apt install libignition-common3-graphics-dev -y
sudo apt install  python3-venv python-is-python3 python3-colcon-common-extensions -y
# Groot depndencies
sudo apt install qtbase5-dev libqt5svg5-dev libzmq3-dev libdw-dev -y

# sudo apt install python3-rosdep2
# rosdep udpate
# rosdep install -y -r -q --from-paths src --ignore-src --rosdistro galactic