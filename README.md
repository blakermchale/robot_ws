# robot_ws
General ROS2 workspace for performing robot control  
## Install  
### 1. ROS install
```bash
sudo apt install ros-foxy-mavlink ros-foxy-geographic-msgs libgeographic-dev ros-foxy-eigen-stl-containers ros-foxy-diagnostic-updater
sudo apt install  python3-venv python-is-python3
```  
### 2. Python3 and venv install
1. Create virtual environment
```bash
mkdir ~/.venv
python3 -m venv ~/.venv/robot --system-site-packages
```  
2. Activate virtual environment
```bash
source ~/.venv/robot/bin/activate
```  
3. Install requirements
```bash
pip3 install -r requirements.txt
```
