# robot_ws
General ROS2 workspace for performing robot control  
## Install  
### 1. ROS install
Install all ROS packages and dependencies of this workspace:
```bash
./scripts/install_ws.sh
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
