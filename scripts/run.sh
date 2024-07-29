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

# FIRST ARGUMENTS: airsim, px4, ros2, gazebo-classic, gazebo
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

# FIRST ARGUMENTS CHECK: airsim, px4, ros2, gazebo-classic, gazebo
if [ $# -eq 0 ]; then
    usageState1 $0
else
    if [ "$1x" != "airsimx" ] && \
       [ "$1x" != "px4x" ] && \
       [ "$1x" != "ros2x" ] && \
       [ "$1x" != "gazebo-classicx" ] && \
       [ "$1x" != "gazebox" ]; then
        EchoRed "[$(basename "$0")] INVALID INPUT \"$1\". PLEASE USE ARGUMENT AMONG
        \"airsim\"
        \"px4\"
        \"ros2\"
        \"gazebo-classic\"
        \"gazebo\""
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# RUN PROCESS PER ARGUMENT
# >>>----------------------------------------------------

# MODULE: AirSim
if [ "$1x" == "airsimx" ]; then
    # SECOND ARGUMENTS: debug, stop, auto, *.sh
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 airsim [debug|auto|*.sh]"
        EchoRed "debug: RUN AIRSIM CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP AIRSIM CONTAINER IF IT IS RUNNING"
        EchoRed "auto: RUN AIRSIM CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)"
        EchoRed "*.sh: RUN AIRSIM CONTAINER IN MANUAL MODE (run specific .sh file)"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop, auto, *.sh
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ] && \
       [ "$2x" != "autox" ] && \
       [[ "$2x" != *".shx" ]]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh airsim
        # ACTIONS: debug, auto, *.sh
        else
            # SET BASIC ENVIRONMENT VARIABLES
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

            # set AIRSIM_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
            sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${AIRSIM_DEPLOY_DIR}/run.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN DEBUG MODE."
                sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${AIRSIM_DEPLOY_DIR}/run.env
            # ACTION: auto. RUN THE CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)
            elif [ "$2x" == "autox" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN AUTO MODE."
                EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL FIND AND RUN .sh FILE IN /home/ue4/workspace/binary DIRECTORY."

                cp ${AIRSIM_SOURCE_DIR}/auto.sh ${AIRSIM_WORKSPACE}/auto.sh
                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/auto.sh\"\'~g" ${AIRSIM_DEPLOY_DIR}/run.env
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (run specific .sh file)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER WITH $2"

                CheckFileExists ${AIRSIM_DEPLOY_DIR}/$2
                CheckFileExecutable ${AIRSIM_DEPLOY_DIR}/$2

                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/$2\"\'~g" ${AIRSIM_DEPLOY_DIR}/run.env
            fi

            # DEPLOY THE CONTAINER
            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER..."
            docker compose -f ${AIRSIM_DEPLOY_DIR}/compose.yml --env-file ${AIRSIM_DEPLOY_DIR}/run.env up
        fi
    fi
# MODULE: PX4-Autopilot
elif [ "$1x" == "px4x" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 px4 [debug]"
        EchoRed "debug: RUN PX4-AUTOPILOT CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP PX4-AUTOPILOT CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh px4
        # ACTIONS: debug
        else
            # SET BASIC ENVIRONMENT VARIABLES
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

            # SET PX4_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
            sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${PX4_DEPLOY_DIR}/run.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER IN DEBUG MODE."
                sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${PX4_DEPLOY_DIR}/run.env
            fi

            # DEPLOY THE CONTAINER
            EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER..."
            docker compose -f ${PX4_DEPLOY_DIR}/compose.yml --env-file ${PX4_DEPLOY_DIR}/run.env up
        fi
    fi
# MODULE: ROS2
elif [ "$1x" == "ros2x" ]; then
    # SECOND ARGUMENTS: debug, stop, build, *.sh
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 ros2 [debug|stop|build|*.sh] (target_workspace)"
        EchoRed "debug: RUN ROS2 CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP ROS2 CONTAINER IF IT IS RUNNING"
        EchoRed "build: BUILD ROS2 PACKAGES INSIDE THE CONTAINER"
        EchoRed "  target_workspace: TARGET WORKSPACE TO BUILD ROS2 PACKAGES (optional, only for \"build\")"
        EchoRed "*.sh: RUN ROS2 CONTAINER IN MANUAL MODE (run specific shell script)"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop, build, *.sh
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ] && \
       [ "$2x" != "buildx" ] && \
       [[ "$2x" != *".shx" ]]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh ros2
        # ACTIONS: debug, build, *.sh
        else
            # SET BASIC ENVIRONMENT VARIABLES
            ROS2_SOURCE_DIR=${REPO_DIR}/ROS2
            ROS2_DEPLOY_DIR=${UNIT_TEST_WORKSPACE}/ROS2
            ROS2_WORKSPACE=${ROS2_DEPLOY_DIR}/workspace

            # CHECK IF ROS2_SOURCE_DIR EXISTS
            CheckDirExists ${ROS2_SOURCE_DIR}

            # CHECK IF ROS2_DEPLOY_DIR EXISTS
            CheckDirExists ${ROS2_DEPLOY_DIR} create

            # CHECK IF ROS2_WORKSPACE EXISTS
            CheckDirExists ${ROS2_WORKSPACE} create

            # COPY ENVIRONMENT VARTIABLE SETTINGS AND COMPOSE SETTINGS TEMPLATE
            cp ${ROS2_SOURCE_DIR}/run.env ${ROS2_DEPLOY_DIR}/run.env
            cp ${ROS2_SOURCE_DIR}/compose.yml ${ROS2_DEPLOY_DIR}/compose.yml

            # SET DISPLAY AND AUDIO-RELATED ENVIRONMENT VARIABLES TO THE .env FILE
            SetComposeDisplay ${ROS2_DEPLOY_DIR}/run.env

            # SET ROS2_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING ROS2_WORKSPACE AS ${ROS2_WORKSPACE}"
            sed -i "s~ROS2_WORKSPACE=\"\"~ROS2_WORKSPACE=${ROS2_WORKSPACE}~" ${ROS2_DEPLOY_DIR}/run.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER IN DEBUG MODE."
                sed -i "s/ROS2_RUN_COMMAND=\"\"/ROS2_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${ROS2_DEPLOY_DIR}/run.env
            # ACTION: build. BUILD ROS2 PACKAGES INSIDE THE CONTAINER
            elif [ "$2x" == "buildx" ]; then
                EchoGreen "[$(basename "$0")] BUILDING ROS2 PACKAGES INSIDE THE CONTAINER."
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE BUILD PROCESS."

                # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
                cp ${ROS2_SOURCE_DIR}/build.sh ${ROS2_WORKSPACE}/build.sh
                cp -r ${BASE_DIR}/include ${ROS2_WORKSPACE}/include

                # IF ADDITIONAL DIRECTORIES ARE PROVIDED, PASS THEM TO THE BUILD SCRIPT
                if [ $# -ge 3 ]; then
                    # DUE TO SED ESCAPE ISSUE, ADDITIONAL ENVIRONMENT VARIABLE IS SET
                    TARGET_ROS2_WORKSPACES=${@:3}
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/build.sh ${TARGET_ROS2_WORKSPACES}\"\'~g" ${ROS2_DEPLOY_DIR}/run.env
                # ELSE, RUN THE BUILD SCRIPT. THIS WILL BUILD ALL PACKAGES IN THE ALL DIRECTORIES THAT HAVE NON-EMPTY 'src' SUBDIRECTORY
                else
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/build.sh\"\'~g" ${ROS2_DEPLOY_DIR}/run.env
                fi 
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (RUN SPECIFIC SHELL SCRIPT)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER WITH $2"

                # CHECK IF THE SCRIPT EXISTS AND EXECUTABLE
                CheckFileExists ${ROS2_WORKSPACE}/$2
                CheckFileExecutable ${ROS2_WORKSPACE}/$2

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$2\"\'~g" ${ROS2_DEPLOY_DIR}/run.env
            fi

            # DEPLOY THE CONTAINER
            EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER..."
            docker compose -f ${ROS2_DEPLOY_DIR}/compose.yml --env-file ${ROS2_DEPLOY_DIR}/run.env up
        fi
    fi
# MODULE: Gazebo-Classic
elif [ "$1x" == "gazebo-classicx" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 gazebo-classic [rdebug]"
        EchoRed "debug: RUN GAZEBO-CLASSIC CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP GAZEBO-CLASSIC CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh gazebo-classic
        # ACTIONS: debug
        else
            # SET BASIC ENVIRONMENT VARIABLES
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

            # SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
            sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER IN DEBUG MODE."
                sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env
            fi

            # DEPLOY THE CONTAINER
            EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER..."
            docker compose -f ${GAZEBO_CLASSIC_DEPLOY_DIR}/compose.yml --env-file ${GAZEBO_CLASSIC_DEPLOY_DIR}/run.env up
        fi
    fi
# MODULE: Gazebo (NOT IMPLEMENTED)
elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET."
    exit 1
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<