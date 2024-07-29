#!/bin/bash

# SCRIPT TO STOP CONTAINERS CREATED FOR TESTING

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
REPO_DIR=$(dirname $(dirname $(readlink -f "$0")))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# DEFINE USAGE FUNCTION
# >>>----------------------------------------------------

usageState1(){
    EchoRed "Usage: $0 [all|airsim|px4|ros2|gazebo-classic|gazebo]"
    EchoRed "all: STOP ALL TEST CONTAINERS"
    EchoRed "airsim: STOP AIRSIM CONTAINER"
    EchoRed "px4: STOP PX4 CONTAINER"
    EchoRed "ros2: STOP ROS2 CONTAINER"
    EchoRed "gazebo-classic: STOP GAZEBO CLASSIC CONTAINER"
    EchoRed "gazebo: STOP GAZEBO CONTAINER"
    exit 1
}

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# CHECK IF ANY INPUT ARGUMENTS ARE PROVIDED
# >>>----------------------------------------------------

if [ $# -eq 0 ]; then
    usageState1 $0
else
    if [ "$1x" != "allx" ] && [ "$1x" != "airsimx" ] && [ "$1x" != "px4x" ] && [ "$1x" != "ros2x" ] && [ "$1x" != "gazebo-classicx" ] && [ "$1x" != "gazebox" ]; then
        EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE USE ARGUMENT AMONG \"airsim\", \"px4\", \"ros2\", \"gazebo-classic\", \"gazebo\"."
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# COMMON STATEMENTS
# >>>----------------------------------------------------

AIRSIM_WORKSPACE=${UNIT_TEST_WORKSPACE}/AirSim
PX4_WORKSPACE=${UNIT_TEST_WORKSPACE}/PX4-Autopilot
ROS2_WORKSPACE=${UNIT_TEST_WORKSPACE}/ROS2
GAZEBO_CLASSIC_WORKSPACE=${UNIT_TEST_WORKSPACE}/Gazebo-Classic
GAZEBO_WORKSPACE=${UNIT_TEST_WORKSPACE}/Gazebo

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# RUN PROCESS PER ARGUMENT
if [ "$1x" == "allx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING AIRSIM CONTAINER..."
    CheckFileExists ${AIRSIM_WORKSPACE}/compose.yml
    CheckFileExists ${AIRSIM_WORKSPACE}/run.env
    docker compose -f ${AIRSIM_WORKSPACE}/compose.yml --env-file ${AIRSIM_WORKSPACE}/run.env down

    EchoYellow "[$(basename "$0")] STOPPING PX4-AUTOPILOT CONTAINER..."
    CheckFileExists ${PX4_WORKSPACE}/compose.yml
    CheckFileExists ${PX4_WORKSPACE}/run.env
    docker compose -f ${PX4_WORKSPACE}/compose.yml --env-file ${PX4_WORKSPACE}/run.env down
elif [ "$1x" == "airsimx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING AIRSIM CONTAINER..."
    CheckFileExists ${AIRSIM_WORKSPACE}/compose.yml
    CheckFileExists ${AIRSIM_WORKSPACE}/run.env
    docker compose -f ${AIRSIM_WORKSPACE}/compose.yml --env-file ${AIRSIM_WORKSPACE}/run.env down
elif [ "$1x" == "px4x" ]; then
    EchoYellow "[$(basename "$0")] STOPPING PX4-AUTOPILOT CONTAINER..."
    CheckFileExists ${PX4_WORKSPACE}/compose.yml
    CheckFileExists ${PX4_WORKSPACE}/run.env
    docker compose -f ${PX4_WORKSPACE}/compose.yml --env-file ${PX4_WORKSPACE}/run.env down
elif [ "$1x" == "ros2x" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "gazebo-classicx" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
fi