#!/bin/bash

# Start x11vnc in the background
x11vnc -forever -create &

# Start noVNC web interface
/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 8080 &

# Source ROS environment and keep the container running
source /opt/ros/noetic/setup.bash
exec "$@"
