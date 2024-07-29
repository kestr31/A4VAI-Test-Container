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
    if [ "$1x" != "allx" ] && \
       [ "$1x" != "airsimx" ] && \
       [ "$1x" != "px4x" ] && \
       [ "$1x" != "ros2x" ] && \
       [ "$1x" != "gazebo-classicx" ] && \
       [ "$1x" != "gazebox" ] && \
       [ "$1x" != "qgcx" ]; then
        EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE USE ARGUMENT AMONG
        \"airsim\"
        \"px4\"
        \"ros2\"
        \"gazebo-classic\"
        \"gazebo\"
        \"qgc\"."
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# COMMON STATEMENTS
# >>>----------------------------------------------------

AIRSIM_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/AirSim
PX4_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/PX4-Autopilot
ROS2_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/ROS2
GAZEBO_CLASSIC_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/Gazebo-Classic
GAZEBO_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/Gazebo
QGC_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/QGroundControl

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# RUN PROCESS PER ARGUMENT
if [ "$1x" == "allx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING AIRSIM CONTAINER..."
    CheckFileExists ${AIRSIM_DEPLOY_DIR}/compose.yml
    CheckFileExists ${AIRSIM_DEPLOY_DIR}/run.env
    docker compose -f ${AIRSIM_DEPLOY_DIR}/compose.yml --env-file ${AIRSIM_DEPLOY_DIR}/run.env down

    EchoYellow "[$(basename "$0")] STOPPING PX4-AUTOPILOT CONTAINER..."
    CheckFileExists ${PX4_DEPLOY_DIR}/compose.yml
    CheckFileExists ${PX4_DEPLOY_DIR}/run.env
    docker compose -f ${PX4_DEPLOY_DIR}/compose.yml --env-file ${PX4_DEPLOY_DIR}/run.env down

    EchoYellow "[$(basename "$0")] STOPPING ROS2 CONTAINER..."
    CheckFileExists ${ROS2_DEPLOY_DIR}/compose.yml
    CheckFileExists ${ROS2_DEPLOY_DIR}/run.env
    docker compose -f ${ROS2_DEPLOY_DIR}/compose.yml --env-file ${ROS2_DEPLOY_DIR}/run.env down

    EchoYellow "[$(basename "$0")] STOPPING GAZEBO-CLASSIC CONTAINER..."
    CheckFileExists ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml
    CheckFileExists ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env
    docker compose -f ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml --env-file ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env down


    EchoYellow "[$(basename "$0")] STOPPING QGroundControl CONTAINER..."
    CheckFileExists ${QGC_DEPLOY_DIR}/compose.yml
    CheckFileExists ${QGC_DEPLOY_DIR}/run.env
    docker compose -f ${QGC_DEPLOY_DIR}/compose.yml --env-file ${QGC_DEPLOY_DIR}/run.env down
elif [ "$1x" == "airsimx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING AIRSIM CONTAINER..."
    CheckFileExists ${AIRSIM_DEPLOY_DIR}/compose.yml
    CheckFileExists ${AIRSIM_DEPLOY_DIR}/run.env
    docker compose -f ${AIRSIM_DEPLOY_DIR}/compose.yml --env-file ${AIRSIM_DEPLOY_DIR}/run.env down
elif [ "$1x" == "px4x" ]; then
    EchoYellow "[$(basename "$0")] STOPPING PX4-AUTOPILOT CONTAINER..."
    CheckFileExists ${PX4_DEPLOY_DIR}/compose.yml
    CheckFileExists ${PX4_DEPLOY_DIR}/run.env
    docker compose -f ${PX4_DEPLOY_DIR}/compose.yml --env-file ${PX4_DEPLOY_DIR}/run.env down
elif [ "$1x" == "ros2x" ]; then
    EchoYellow "[$(basename "$0")] STOPPING ROS2 CONTAINER..."
    CheckFileExists ${ROS2_DEPLOY_DIR}/compose.yml
    CheckFileExists ${ROS2_DEPLOY_DIR}/run.env
    docker compose -f ${ROS2_DEPLOY_DIR}/compose.yml --env-file ${ROS2_DEPLOY_DIR}/run.env down
elif [ "$1x" == "gazebo-classicx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING GAZEBO-CLASSIC CONTAINER..."
    CheckFileExists ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml
    CheckFileExists ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env
    docker compose -f ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml --env-file ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env down
elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "qgcx" ]; then
    EchoYellow "[$(basename "$0")] STOPPING QGroundControl CONTAINER..."
    CheckFileExists ${QGC_DEPLOY_DIR}/compose.yml
    CheckFileExists ${QGC_DEPLOY_DIR}/run.env
    docker compose -f ${QGC_DEPLOY_DIR}/compose.yml --env-file ${QGC_DEPLOY_DIR}/run.env down
fi