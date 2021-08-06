default: build

TOP := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
# CMAKE_ARGS = ""
# SKIPPED_PKGS = ""

CMAKE_ARGS = " -DCMAKE_BUILD_TYPE=Release"
SKIPPED_PKGS = "px4 darknet_vendor openrobotics_darknet_ros"


build:
	
	colcon build --symlink-install --cmake-args ${CMAKE_ARGS} --packages-skip px4

clean:
	rm -rf install/ build/ log/

.PHONY: \
	build clean
