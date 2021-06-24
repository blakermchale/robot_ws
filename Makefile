default: build

TOP := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
# CMAKE_ARGS = ""
# SKIPPED_PKGS = ""

CMAKE_ARGS = " -DCMAKE_BUILD_TYPE=Release"
SKIPPED_PKGS = "px4 darknet_vendor openrobotics_darknet_ros"


build:
	colcon build --symlink-install --cmake-args ${CMAKE_ARGS} --packages-skip px4
	@true

clean:
	rm -rf install/ build/ log/
	@true

word-dash = $(word $2,$(subst -, ,$1))
pkg = $(call word-dash,$*,1)
clean-%:
	rm -rf install/${pkg}/ build/${pkg}/
	@true

%:
	colcon build --symlink-install --cmake-args ${CMAKE_ARGS} --packages-skip px4 --packages-select $@

.PHONY: \
	build clean
