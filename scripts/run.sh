#!/bin/bash

# SCRIPT TO RUN CONTAINER FOR TESTING

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname "$0")
REPO_DIR=$(dirname "${BASEDIR}")

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# DEFINE USAGE FUNCTION
# >>>----------------------------------------------------

usageState1(){
    EchoRed "Usage: $0 [airsim|px4|ros2|gazebo-classic|gazebo]"
    EchoRed "airsim: RUN AIRSIM CONTAINER"
    EchoRed "px4: RUN PX4 CONTAINER"
    EchoRed "ros2: RUN ROS2 CONTAINER"
    EchoRed "gazebo-classic: RUN GAZEBO CLASSIC CONTAINER"
    EchoRed "gazebo: RUN GAZEBO CONTAINER"
    exit 1
}

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# CHECK IF ANY INPUT ARGUMENTS ARE PROVIDED
# >>>----------------------------------------------------

if [ $# -eq 0 ]; then
    usageState1 $0
else
    if [ "$1x" != "airsimx" ] && [ "$1x" != "px4x" ] && [ "$1x" != "ros2x" ] && [ "$1x" != "gazebo-classicx" ] && [ "$1x" != "gazebox" ]; then
        EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE USE ARGUMENT AMONG \"airsim\", \"px4\", \"ros2\", \"gazebo-classic\", \"gazebo\"."
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# RUN PROCESS PER ARGUMENT
if [ "$1x" == "airsimx" ]; then
    usageState2(){
        EchoRed "Usage: $0 airsim [debug|auto|*.sh]"
        EchoRed "debug: RUN AIRSIM CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "auto: RUN AIRSIM CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)"
        EchoRed "*.sh: RUN AIRSIM CONTAINER IN MANUAL MODE (run specific .sh file)"
        exit 1
    }

    # also check if input is in *.sh format
    if [ "$2x" != "debugx" ] && [ "$2x" != "autox" ] && [[ "$2x" != *".shx" ]]; then
        usageState2 $0
        exit 1
    else
        # SET THE AIRSIM DIRECTORY
        AIRSIM_DIR=${REPO_DIR}/AirSim
        source ${AIRSIM_DIR}/airsim.env

        # CHECK IF AIRSIM DIRECTORY EXISTS
        CheckDirExists ${AIRSIM_DIR}

        # CHECK IF AIRSIM_WORKSPACE EXISTS
        CheckDirExists ${AIRSIM_WORKSPACE} create

        # BACKUP airsim.env TEMPLATE if airsim.env.bak DOES NOT EXIST
        CheckFileExists ${AIRSIM_DIR}/airsim.env.bak cp ${AIRSIM_DIR}/airsim.env

        # CHECK IF USING WAYLAND
        if [ -z $WAYLAND_DISPLAY ]; then
            EchoGreen "[$(basename "$0")] WAYLAND DISPLAY NOT SET. SETTING VARIABLE \"DISPLAY\"."
            sed -i "s/AIRSIM_DISPLAY=\"\"/AIRSIM_DISPLAY=${DISPLAY}/" ${AIRSIM_DIR}/airsim.env
        else
            EchoYellow "[$(basename "$0")] WAYLAND DISPLAY SET. SETTING VARIABLE \"WAYLAND_DISPLAY\"."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE X11 DISPLAY."
            sed -i "s/AIRSIM_WAYLAND_DISPLAY=\"\"/AIRSIM_WAYLAND_DISPLAY=${WAYLAND_DISPLAY}/" ${AIRSIM_DIR}/airsim.env
        fi

        EchoGreen "[$(basename "$0")] SETTING PULSEAUDIO_DIR AS ${XDG_RUNTIME_DIR}/pulse"
        sed -i "s~AIRSIM_PULSEAUDIO_DIR=\"\"~AIRSIM_PULSEAUDIO_DIR=${XDG_RUNTIME_DIR}/pulse~" ${AIRSIM_DIR}/airsim.env

        if [ "$2x" == "debugx" ]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN DEBUG MODE."
            sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${AIRSIM_DIR}/airsim.env
        elif [ "$2x" == "autox" ]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN AUTO MODE."
            EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL FIND AND RUN .sh FILE IN /home/ue4/workspace/binary DIRECTORY."

            cp ${AIRSIM_DIR}/auto.sh ${AIRSIM_WORKSPACE}/auto.sh
            sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/auto.sh\"\'~g" ${AIRSIM_DIR}/airsim.env
        elif [[ "$2x" == *".shx" ]]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER WITH $2"
            EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL $2."

            CheckFileExists ${AIRSIM_DIR}/$2
            CheckFileExecutable ${AIRSIM_DIR}/$2

            cp ${AIRSIM_DIR}/$2 ${AIRSIM_WORKSPACE}/$2
            sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/$2\"\'~g" ${AIRSIM_DIR}/airsim.env
        fi

        EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER..."
        docker compose -f ${AIRSIM_DIR}/compose.yml --env-file ${AIRSIM_DIR}/airsim.env up
    fi
elif [ "$1x" == "px4x" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
elif [ "$1x" == "ros2x" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
elif [ "$1x" == "gazebo-classicx" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
fi