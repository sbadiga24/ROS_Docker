# Step 1: Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Step 2: Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Step 3: Update and install basic dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    lsb-release \
    gnupg2 \
    build-essential \
    cmake \
    python3-pip \
    sudo \
    && apt-get clean

# Step 4: Add ROS Noetic repository
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Step 5: Install ROS Noetic and Gazebo 11
RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    gazebo11 \
    ros-noetic-gazebo-ros-pkgs \
    && apt-get clean

# Step 6: Source ROS setup script
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
SHELL ["/bin/bash", "-c"]

# Step 7: Install noVNC and GUI tools
RUN apt-get update && apt-get install -y \
    novnc \
    websockify \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    && apt-get clean

# Step 8: Set up noVNC
RUN mkdir -p /opt/noVNC && cd /opt/noVNC && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz && \
    tar -xzf v1.4.0.tar.gz && \
    rm v1.4.0.tar.gz && \
    mv noVNC-1.4.0/* .

# Step 9: Expose necessary ports
EXPOSE 8080 5900

# Step 10: Copy and set up start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Step 11: Define the entrypoint
ENTRYPOINT ["/start.sh"]
