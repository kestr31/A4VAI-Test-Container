#!/bin/bash

# SCRIPT TO RUN CONTAINER FOR TESTING

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
        AIRSIM_SOURCE_DIR=${REPO_DIR}/AirSim
        AIRSIM_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/AirSim
        AIRSIM_WORKSPACE=${AIRSIM_DEPLOY_DIR}/workspace

        # CHECK IF AIRSIM SOURCE DIRECTORY EXISTS
        CheckDirExists ${AIRSIM_SOURCE_DIR}

        # CHECK IF AIRSIM_DEPLOY_DIR EXISTS
        CheckDirExists ${AIRSIM_DEPLOY_DIR} create

        # CHECK IF AIRSIM_WORKSPACE EXISTS
        CheckDirExists ${AIRSIM_WORKSPACE} create

        # COPY ENVIRONMENT VARTIABLE SETTINGS AND COMPOSE SETTINGS TEMPLATE
        cp ${AIRSIM_SOURCE_DIR}/run.env ${AIRSIM_DEPLOY_DIR}/run.env
        cp ${AIRSIM_SOURCE_DIR}/compose.yml ${AIRSIM_DEPLOY_DIR}/compose.yml

        # SET DISPLAY AND AUDIO-RELATED ENVIRONMENT VARIABLES TO THE .env FILE
        SetComposeDisplay ${AIRSIM_DEPLOY_DIR}/run.env

        EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
        sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${AIRSIM_DEPLOY_DIR}/run.env

        if [ "$2x" == "debugx" ]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN DEBUG MODE."
            sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${AIRSIM_DEPLOY_DIR}/run.env
        elif [ "$2x" == "autox" ]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN AUTO MODE."
            EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL FIND AND RUN .sh FILE IN /home/ue4/workspace/binary DIRECTORY."

            cp ${AIRSIM_SOURCE_DIR}/auto.sh ${AIRSIM_WORKSPACE}/auto.sh
            sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/auto.sh\"\'~g" ${AIRSIM_DEPLOY_DIR}/run.env
        elif [[ "$2x" == *".shx" ]]; then
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER WITH $2"
            EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL $2."

            CheckFileExists ${AIRSIM_DEPLOY_DIR}/$2
            CheckFileExecutable ${AIRSIM_DEPLOY_DIR}/$2

            sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/$2\"\'~g" ${AIRSIM_DEPLOY_DIR}/run.env
        fi

        EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER..."
        docker compose -f ${AIRSIM_DEPLOY_DIR}/compose.yml --env-file ${AIRSIM_DEPLOY_DIR}/run.env up
    fi
elif [ "$1x" == "px4x" ]; then
    usageState2(){
        EchoRed "Usage: $0 px4 [debug]"
        EchoRed "debug: RUN PX4-AUTOPILOT CONTAINER IN DEBUG MODE (sleep infinity)"
        exit 1
    }

    # also check if input is in *.sh format
    if [ "$2x" != "debugx" ]; then
        usageState2 $0
        exit 1
    else
        PX4_SOURCE_DIR=${REPO_DIR}/PX4-Autopilot
        PX4_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/PX4-Autopilot
        PX4_WORKSPACE=${PX4_DEPLOY_DIR}/workspace

        # CHECK IF PX4_SOURCE_DIR EXISTS
        CheckDirExists ${PX4_SOURCE_DIR}

        # CHECK IF PX4_DEPLOY_DIR EXISTS
        CheckDirExists ${PX4_DEPLOY_DIR} create

        # CHECK IF PX4_WORKSPACE EXISTS
        CheckDirExists ${PX4_WORKSPACE} create

        # COPY ENVIRONMENT VARTIABLE SETTINGS AND COMPOSE SETTINGS TEMPLATE
        cp ${PX4_SOURCE_DIR}/run.env ${PX4_DEPLOY_DIR}/run.env
        cp ${PX4_SOURCE_DIR}/compose.yml ${PX4_DEPLOY_DIR}/compose.yml

        # SET DISPLAY AND AUDIO-RELATED ENVIRONMENT VARIABLES TO THE .env FILE
        SetComposeDisplay ${PX4_DEPLOY_DIR}/run.env

        EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
        sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${PX4_DEPLOY_DIR}/run.env

        if [ "$2x" == "debugx" ]; then
            EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER IN DEBUG MODE."
            sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${PX4_DEPLOY_DIR}/run.env
        fi

        EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER..."
        docker compose -f ${PX4_DEPLOY_DIR}/compose.yml --env-file ${PX4_DEPLOY_DIR}/run.env up
    fi
elif [ "$1x" == "ros2x" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
elif [ "$1x" == "gazebo-classicx" ]; then
    usageState2(){
        EchoRed "Usage: $0 gazebo-classic [rdebug]"
        EchoRed "debug: RUN GAZEBO-CLASSIC CONTAINER IN DEBUG MODE (sleep infinity)"
        exit 1
    }

    # also check if input is in *.sh format
    if [ "$2x" != "debugx" ]; then
        usageState2 $0
        exit 1
    else
        GAZEBO_CLASSIC_SOURCE_DIR=${REPO_DIR}/Gazebo-Classic
        GAZEBO_CLASSIC_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/Gazebo-Classic
        GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_DEPLOY_DIR}/workspace

        # CHECK IF PX4_SOURCE_DIR EXISTS
        CheckDirExists ${GAZEBO_CLASSIC_SOURCE_DIR}

        # CHECK IF PX4_DEPLOY_DIR EXISTS
        CheckDirExists ${GAZEBO_CLASSIC_DEPLOY_DIR} create

        # CHECK IF PX4_WORKSPACE EXISTS
        CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE} create

        # COPY ENVIRONMENT VARTIABLE SETTINGS AND COMPOSE SETTINGS TEMPLATE
        cp ${GAZEBO_CLASSIC_SOURCE_DIR}/run.env ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env
        cp ${GAZEBO_CLASSIC_SOURCE_DIR}/compose.yml ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml

        # SET DISPLAY AND AUDIO-RELATED ENVIRONMENT VARIABLES TO THE .env FILE
        SetComposeDisplay ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env

        EchoGreen "[$(basename "$0")] SETTING GAZEBO-CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
        sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env

        if [ "$2x" == "debugx" ]; then
            EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER IN DEBUG MODE."
            sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env
        fi

        EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER..."
        docker compose -f ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml --env-file ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env up
    fi
elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
fi