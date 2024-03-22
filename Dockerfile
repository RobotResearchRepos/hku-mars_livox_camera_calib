FROM osrf/ros:melodic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# apt packages

RUN apt-get update \
 && apt-get install -y libceres-dev \
 && rm -rf /var/lib/apt/lists/*

# Fix https://github.com/hku-mars/livox_camera_calib/issues/82

RUN mv /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4.h.bak \
 && mv /usr/include/flann/ext/lz4hc.h /usr/include/flann/ext/lz4.h.bak \
 && ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h \
 && ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h

# Code repository

RUN mkdir -p /catkin_ws/src/

RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/hku-mars_livox_camera_calib \
      /catkin_ws/src/livox_camera_calib

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make
 
 
