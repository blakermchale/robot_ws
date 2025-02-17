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

### 3. CUDA
#### Ubuntu
https://linoxide.com/how-to-install-cuda-on-ubuntu/  
#### WSL
Install from here https://ubuntu.com/tutorials/enabling-gpu-acceleration-on-ubuntu-on-wsl2-with-the-nvidia-cuda-platform#3-install-nvidia-cuda-on-ubuntu  
Create link from Windows CUDA lib to local CUDA folder:
```
sudo ln -s /mnt/c/Windows/System32/lxss/lib/libcuda.so /usr/local/cuda/lib64/libcuda.so
```  
#### Extra
Had to add CMAKE_CUDA_COMPILER to build command. This shouldn't be set by the user.
## Interesting Resources
https://docs.ros.org/en/rolling/Related-Projects/Nvidia-ROS2-Projects.html  
