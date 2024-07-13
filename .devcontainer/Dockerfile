FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
RUN useradd -ms /bin/bash ros -g root -G sudo -p "$(openssl passwd -1 ros)"

##########################
# Install PX4 dependencies
##########################
# https://github.com/PX4/PX4-containers/blob/master/docker/Dockerfile_base-focal
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get -y --quiet --no-install-recommends install \
		bzip2 \
		ca-certificates \
		ccache \
		cmake \
		cppcheck \
		curl \
		dirmngr \
		doxygen \
		file \
		g++ \
		gcc \
		gdb \
		git \
		gnupg \
		gosu \
		lcov \
		libfreetype6-dev \
		libgtest-dev \
		libpng-dev \
		libssl-dev \
		lsb-release \
		make \
		ninja-build \
		openjdk-8-jdk \
		openjdk-8-jre \
		openssh-client \
		pkg-config \
		python3-dev \
		python3-pip \
		rsync \
		shellcheck \
		tzdata \
		unzip \
		valgrind \
		wget \
		xsltproc \
		zip \
		libgstreamer-plugins-base1.0-dev \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# gtest
RUN cd /usr/src/gtest \
	&& mkdir build && cd build \
	&& cmake .. && make -j$(nproc) \
	&& find . -name \*.a -exec cp {} /usr/lib \; \
	&& cd .. && rm -rf build

# Install Python 3 pip build dependencies first.
RUN python3 -m pip install --upgrade pip wheel setuptools

# # Python 3 dependencies installed by pip
# RUN python3 -m pip install argparse argcomplete coverage cerberus empy jinja2 kconfiglib \
# 		matplotlib==3.0.* numpy nunavut>=1.1.0 packaging pkgconfig pyros-genmsg pyulog \
# 		pyyaml requests serial six toml psutil pyulog wheel jsonschema pynacl

# astyle v3.1
RUN wget -q https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.1/astyle_3.1_linux.tar.gz -O /tmp/astyle.tar.gz \
	&& cd /tmp && tar zxf astyle.tar.gz && cd astyle/src \
	&& make -f ../build/gcc/Makefile -j$(nproc) && cp bin/astyle /usr/local/bin \
	&& rm -rf /tmp/*

# create user with id 1001 (jenkins docker workflow default)
RUN useradd --shell /bin/bash -u 1001 -c "" -m user && usermod -a -G dialout user

# setup virtual X server
# RUN mkdir /tmp/.X11-unix && \
# 	chmod 1777 /tmp/.X11-unix && \
# 	chown -R root:root /tmp/.X11-unix
# ENV DISPLAY :99

ENV CCACHE_UMASK=000
ENV FASTRTPSGEN_DIR="/usr/local/bin/"
ENV PATH="/usr/lib/ccache:$PATH"
ENV TERM=xterm
ENV TZ=UTC

# SITL UDP PORTS
EXPOSE 14556/udp
EXPOSE 14557/udp

# create and start as LOCAL_USER_ID
# COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# CMD ["/bin/bash"]

###############
# Install ros2
###############
# https://github.com/PX4/PX4-containers/blob/master/docker/Dockerfile_ros2-galactic
ENV ROS_DISTRO humble

# setup ros2 keys
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
# setup sources.list
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# install bootstrap tools
RUN apt-get update \
	&& apt-get install --quiet -y \
		python3-colcon-common-extensions \
		python3-colcon-mixin \
		python3-rosdep \
		python3-vcstool \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# install ros2 desktop
RUN apt-get install --quiet --no-install-recommends -y \
		ros-$ROS_DISTRO-desktop \
		ros-$ROS_DISTRO-launch-testing-ament-cmake \
		ros-$ROS_DISTRO-ros2bag \
		ros-$ROS_DISTRO-rosidl-generator-dds-idl \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Install Python 3 packages needed for testing
RUN pip3 install -U \
		argcomplete \
		flake8 \
		flake8-blind-except \
		flake8-builtins \
		flake8-class-newline \
		flake8-comprehensions \
		flake8-deprecated \
		flake8-docstrings \
		flake8-import-order \
		flake8-quotes \
		pytest-repeat \
		pytest-rerunfailures

# bootstrap rosdep
RUN rosdep init && rosdep update

# setup colcon mixin and metadata
RUN colcon mixin add default \
		https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml \
	&& colcon mixin update \
	&& colcon metadata add default \
		https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml \
	&& colcon metadata update



###########
# THIS REPO
###########

# Installing new cmake https://askubuntu.com/a/865294
# RUN apt purge -y cmake
RUN apt update && apt install -y software-properties-common lsb-release && apt clean all
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt update
RUN apt install -y kitware-archive-keyring
# RUN rm /etc/apt/trusted.gpg.d/kitware.gpg
RUN apt update
RUN apt install -y cmake

# ** [Optional] Uncomment this section to install additional packages. **
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends ros-${ROS_DISTRO}-gazebo-ros \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog

# RUN echo \
# "export CUDA_HOME=/usr/local/cuda \n\
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64 \n\
# export PATH=$PATH:$CUDA_HOME/bin" >> /home/ros/.bashrc

# libraries for opengl in the container
RUN apt-get update \
 && apt-get install -y -qq --no-install-recommends \
  libglvnd0 \
  libgl1 \
  libglx0 \
  libegl1 \
  libxext6 \
  libx11-6 \
  libyaml-cpp-dev \
  tmuxinator \
  # https://github.com/tianon/docker-brew-ubuntu-core/issues/75#issuecomment-386444576 bash autocompletion
  bash-completion \
  python-is-python3 \
  # Groot dependencies
  qtbase5-dev libqt5svg5-dev libzmq3-dev libdw-dev \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN apt-get update
ENV DEBIAN_FRONTEND=dialog

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

ENV QT_X11_NO_MITSHM=1

# Cuda env vars  https://github.com/NVIDIA/nvidia-docker/issues/1222
# ENV CUDACXX /usr/local/cuda/bin/nvcc
# ENV CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc

# Set up auto-source of workspace for ros user
# USER ros
# WORKDIR /home/ros
ARG WORKSPACE
ENV WORKSPACE ${WORKSPACE}

#TODO: test the colcon clean
RUN apt install python3-colcon-clean -y

#TODO: add packages to rosdep http://docs.ros.org/en/independent/api/rosdep/html/contributing_rules.html
# rosdep tag info https://www.ros.org/reps/rep-0140.html#depend-multiple
RUN pip3 install msgpack-rpc-python
RUN pip3 install airsim navpy cmd2

# TODO: install geographiclib datasets on start, requires package dependencies to be installed (specifically geographiclib)
RUN apt install ros-${ROS_DISTRO}-mavros -y
COPY ./scripts/install_geographiclib_datasets.sh ./install_geographiclib_datasets.sh
RUN ./install_geographiclib_datasets.sh && rm ./install_geographiclib_datasets.sh

# RUN echo "source /opt/ros/humble/setup.bash" >> /home/ros/.bashrc
COPY .devcontainer/setup.sh ./setup.sh
RUN cat ./setup.sh >> /home/ros/.bashrc && rm ./setup.sh

ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
# Install gazebo from stable source for WSL fix
# NOTE: can remove once gz >=8 is updated on ros packages
# https://gazebosim.org/docs/harmonic/install_ubuntu#binary-installation-on-ubuntu
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
	&& apt update \
	&& apt install ros-humble-ros-gzharmonic -y
# RUN apt install ros-humble-ros-gzharmonic-sim ros-humble-gzharmonic-bridge
# RUN apt install ros-${ROS_DISTRO}-ros-ign-bridge ros-${ROS_DISTRO}-ros-ign-gazebo -y
COPY src /tmp/src
# cuda-dev errors on WSL, part of darknet
RUN cd /tmp && apt-get update && rosdep update && rosdep install --from-paths src --ignore-src  \
	--skip-keys=nvidia-cuda-dev --skip-keys=nvidia-cuda \
	--skip-keys=ros_ign_bridge --skip-keys=ros_ign_gazebo \
	--skip-keys=ros_gz_sim --skip-keys=ros_gz_bridge \
	--skip-keys=mav_msgs \
	--skip-keys rostest --skip-keys tf --skip-keys rospy --skip-keys roscpp --skip-keys catkin \
	--skip-keys message_runtime --skip-keys message_generation \
	-y --as-root apt:false
RUN rm -rf /tmp/src
