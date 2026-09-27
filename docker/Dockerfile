ISAAC_SIM_VERSION=5.1.0
ROS_DISTRO=jazzy

FROM nvcr.io/nvidia/isaac-sim:${ISAAC_SIM_VERSION}

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=${ROS_DISTRO}
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


# Configure locale and install tools needed to add the ROS repository.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
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

# Install ROS 2 dependencies for the selected ROS distro.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-ros-base \
    ros-${ROS_DISTRO}-rmw-fastrtps-cpp \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-ur-description \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-rqt-graph \
    ros-${ROS_DISTRO}-ackermann-msgs \
    && rm -rf /var/lib/apt/lists/*

# Automatically source ROS 2 in Bash terminals.
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc

# Use the standard non-root Isaac Sim container user.
USER 1234:1234

WORKDIR /isaac-sim

CMD ["/bin/bash"]
