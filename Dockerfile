ARG ISAACSIM_VERSION=6.0.1

FROM nvcr.io/nvidia/isaac-sim:${ISAACSIM_VERSION}

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


# Configure locale and install tools needed to add the ROS repository.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg2 \
    locales \
    software-properties-common \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && add-apt-repository -y universe \
    && rm -rf /var/lib/apt/lists/*

# Add the official ROS 2 repository.
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
       | gpg --dearmor -o /etc/apt/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo ${VERSION_CODENAME}) main" \
       > /etc/apt/sources.list.d/ros2.list

# Install ROS 2 Jazzy and Tutorial 6 dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-ros-base \
    ros-jazzy-rmw-fastrtps-cpp \
    ros-jazzy-xacro \
    ros-jazzy-ur-description \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-rviz2 \
    ros-jazzy-rqt-graph \
    ros-jazzy-ackermann-msgs \
    && rm -rf /var/lib/apt/lists/*

# Automatically source ROS 2 in Bash terminals.
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc

# Use the standard non-root Isaac Sim container user.
USER 1234:1234

WORKDIR /isaac-sim

CMD ["/bin/bash"]