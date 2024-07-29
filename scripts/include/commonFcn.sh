#!/bin/bash

# FUNCTION DEFINITIONS FOR OTHER RUN SCRIPTS

# FUNCTION TO ECHO INPUT IN GREEN
# >>>-------------------------------------------------------------
# INPUTS:
# $1: INPUT TO ECHO
# ----------------------------------------------------------------
EchoGreen(){
    echo -e "\e[32m$1\e[0m"
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION TO ECHO INPUT IN RED
# >>>-------------------------------------------------------------
# INPUTS:
# $1: INPUT TO ECHO
# ----------------------------------------------------------------
EchoRed(){
    echo -e "\e[31m$1\e[0m"
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION TO ECHO INPUT IN YELLOW
# >>>-------------------------------------------------------------
# INPUTS:
# $1: INPUT TO ECHO
# ----------------------------------------------------------------
EchoYellow(){
    echo -e "\e[33m$1\e[0m"
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION TO PRINT A LINE OF BOXLINES
# >>>-------------------------------------------------------------
EchoBoxLine(){
    echo $(printf '%.s─' $(seq 1 $(tput cols)))
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION TO CHECK THE EXISTENCE OF THE DIRECTORY
# >>>-------------------------------------------------------------
# INPUTS:
# $1: DIRECTORY TO CHECK
# $2: CREATE DIRECTORY IF NOT EXISTS (true/false, default: false)
# ----------------------------------------------------------------
CheckDirExists(){
    usage(){
        EchoRed "Usage: $0 [directory] (create|git) [repository] (branch)"
        EchoRed "create: Create the directory if not exists (optional)"
        EchoRed "git: Clone the repository if not exists (MANDATORY - only for git)"
        EchoRed "repository: Repository to clone (optional - only for git)"
        EchoBoxLine
        exit 1
    }

    if [ $# -eq 0 ]; then
        EchoRed "[$(basename "$0")] NO ARGUMENT PROVIDED."
        usage $0
    else
        if [ "$2x" != "createx" ] && [ "$2x" != "gitx" ] && [ "$2x" != "x" ]; then
            EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE ONLY USE \"create\" OR \"git\" FOR THE SECOND ARGUMENT."
            EchoBoxLine
            exit 1
        elif [ "$2x" == "gitx" ] && [ $# -lt 3 ]; then
            EchoRed "[$(basename "$0")] REPOSITORY IS REQUIRED FOR THE git ARGUMENT."
            EchoBoxLine
            exit 1
        fi 
    fi

    # SET FLAG IF create IS PROVIDED
    if [ "$2x" == "createx" ]; then
        FLAG_CREATE=true
    else
        FLAG_CREATE=false
    fi

    # # SET FLAG IF git IS PROVIDED
    if [ "$2x" == "gitx" ]; then
        FLAG_GIT=true
        GIT_REPO=$3
        # SET BRANCH IF PROVIDED
    else
        FLAG_GIT=false
    fi

    # CHECK IF THE DIRECTORY EXISTS
    if ! [ -d "$1" ]; then
        EchoRed "[$(basename "$0")] DIRECTORY \"$1\" DOES NOT EXIST."
        # CREATE THE DIRECTORY IF FLAG_CREATE IS TRUE
        if [ "$FLAG_CREATE" == true ]; then
            EchoYellow "[$(basename "$0")] THE DIRECTORY \"$1\" WILL BE CREATED."
            mkdir -p $1
        elif [ "$FLAG_GIT" == true ]; then
            EchoYellow "[$(basename "$0")] CLONING THE REPOSITORY TO \"$1\"."
            if [ $# -eq 4 ]; then
                git clone $3 -b $4 $1
            else
                git clone $3 $1
            fi
        else
            EchoRed "[$(basename "$0")] PLEASE CHECK IF THE DIRECTORY \"$1\" EXISTS."
            exit 1
        fi
    else
        EchoYellow "[$(basename "$0")] DIRECTORY \"$1\" ALREADY EXISTS."
    fi

}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION CHECK IF THE DIRECTORY IS EMPTY
# >>>-------------------------------------------------------------
# INPUTS:
# $1: DIRECTORY TO CHECK
# ----------------------------------------------------------------
CheckDirEmpty(){
    usage(){
        EchoRed "Usage: $0 [directory] (delete)"
        EchoRed "create: Delete the directory if empty (optional)"
        EchoBoxLine
        exit 1
    }

    if [ $# -eq 0 ]; then
        EchoRed "[$(basename "$0")] NO ARGUMENT PROVIDED."
        usageState1 $0
    else
        if [ "$2x" != "deletex" ] && [ "$2x" != "x" ]; then
            EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE ONLY USE \"delete\" FOR THE SECOND ARGUMENT."
            EchoBoxLine
            exit 1
        fi 
    fi

    # SET FLAG IF delete IS PROVIDED
    if [ "$2x" == "deletex" ]; then
        FLAG_DELETE=true
    else
        FLAG_DELETE=false
    fi


    # CHECK IF THE DIRECTORY IS EMPTY
    if [ -z "$(ls -A $1)" ]; then
        EchoRed "[$(basename "$0")] DIRECTORY \"$1\" IS EMPTY."
        if [ "$FLAG_DELETE" == true ]; then
            EchoYellow "[$(basename "$0")] THE DIRECTORY \"$1\" WILL BE DELETED."
            rm -rf $1
        else
            EchoRed "[$(basename "$0")] PLEASE CHECK IF CONTENTS OF THE DIRECTORY \"$1\" ARE REMOVED."
            EchoBoxLine
            exit 1
        fi
    fi
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUCNTION TO CHECK IF THE FILE EXISTS
# >>>-------------------------------------------------------------
# INPUTS:
# $1: FILE TO CHECK
# ----------------------------------------------------------------
CheckFileExists(){
    usage(){
        EchoRed "Usage: $0 [directory] (cp) [fileToCopy]"
        EchoRed "cp: Copy the file if not exists (optional)"
        EchoRed "fileToCopy: File to copy (Must be Provided - only for cp)"
        EchoBoxLine
        exit 1
    }

    if [ $# -eq 0 ]; then
        EchoRed "[$(basename "$0")] NO ARGUMENT PROVIDED."
        usageState1 $0
    else
        if [ "$2x" != "cpx" ] && [ "$2x" != "x" ]; then
            EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE ONLY USE \"cp\" FOR THE SECOND ARGUMENT."
            EchoBoxLine
            exit 1
        elif [ "$2x" == "cpx" ]; then
            if [ $# -lt 3 ]; then
                EchoRed "[$(basename "$0")] FILE TO COPY IS REQUIRED FOR THE cp ARGUMENT."
                EchoBoxLine
                exit 1
            elif ! [ -f "$3" ]; then
                EchoRed "[$(basename "$0")] PLEASE CHECK IF THE FILE \"$1\" EXISTS."
                EchoBoxLine
                exit 1
            fi
        fi 
    fi

    # SET FLAG IF cp IS PROVIDED
    if [ "$2x" == "cpx" ]; then
        FLAG_COPY=true
    else
        FLAG_COPY=false
    fi


    # CHECK IF THE FILE EXISTS
    if ! [ -f "$1" ]; then
        EchoRed "[$(basename "$0")] FILE \"$1\" DOES NOT EXIST."
        if [ "$FLAG_COPY" == true ]; then
            EchoYellow "[$(basename "$0")] COPYING FILE \"$3\" TO \"$1\"."
            cp $3 $1
        else
            EchoRed "[$(basename "$0")] PLEASE CHECK IF THE FILE \"$1\" EXISTS."
            EchoBoxLine
            exit 1
        fi
    fi
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# FUNCTION TO CHECK IF THE FILE IS EXECUTABLE
# >>>-------------------------------------------------------------
# INPUTS:
# $1: FILE TO CHECK
# $2: MAKE FILE EXECUTABLE (optional)
# ----------------------------------------------------------------
CheckFileExecutable(){
    usage(){
        EchoRed "Usage: $0 [file] (x)"
        EchoRed "x: Make file executable (optional)"
        EchoBoxLine
        exit 1
    }

    if [ $# -eq 0 ]; then
        EchoRed "[$(basename "$0")] NO ARGUMENT PROVIDED."
        usageState1 $0
    else
        if [ "$2x" != "xx" ] && [ "$2x" != "x" ]; then
            EchoRed "[$(basename "$0")] INVALID INPUT. PLEASE ONLY USE \"x\" FOR THE SECOND ARGUMENT."
            EchoBoxLine
            exit 1
        fi 
    fi

    # SET FLAG IF x IS PROVIDED
    if [ "$2x" == "xx" ]; then
        FLAG_EXEC=true
    else
        FLAG_EXEC=false
    fi

    # CHECK IF THE FILE IS EXECUTABLE
    if ! [ -x "$1" ]; then
        EchoRed "[$(basename "$0")] FILE \"$1\" IS NOT EXECUTABLE."
        if [ "$FLAG_EXEC" == true ]; then
            EchoYellow "[$(basename "$0")] MAKING FILE \"$1\" EXECUTABLE."
            chmod +x $1
        else
            EchoRed "[$(basename "$0")] PLEASE CHECK IF THE FILE \"$1\" IS EXECUTABLE."
            EchoBoxLine
            exit 1
        fi
    fi
}


# FUNCTION TO SET DISPLAY-RELATED COMPOSE ENVIRONMENT VARIABLES
# >>>-------------------------------------------------------------
# INPUTS:
# $1: FILE TO MODIFY
# ----------------------------------------------------------------
SetComposeDisplay(){
    usage(){
        EchoRed "Usage: $0 [file]"
        EchoBoxLine
        exit 1
    }

    if [ $# -eq 0 ]; then
        EchoRed "[$(basename "$0")] NO ARGUMENT PROVIDED."
        usageState1 $0
    fi

    # CHECK IF THE FILE EXISTS
    CheckFileExists $1

    # READ LINE TO BE CHANGED FIRST
    DISPLAY_LINE=$(grep -E '_DISPLAY=""' $1 | grep -v "WAYLAND_DISPLAY")
    WAYLAND_DISPLAY_LINE=$(grep '_WAYLAND_DISPLAY=""' $1)
    PULSEAUDIO_LINE=$(grep '_PULSEAUDIO_DIR=""' $1)

    if [ -z "${DISPLAY_LINE}" ]; then
        EchoRed "[$(basename "$0")] *_DISPLAY LINE DOES NOT EXIST."
    elif [ -z "${WAYLAND_DISPLAY_LINE}" ]; then
        EchoRed "[$(basename "$0")] *_WAYLAND_DISPLAY DOES NOT EXIST."
    elif [ -z "${PULSEAUDIO_LINE}" ]; then
        EchoRed "[$(basename "$0")] *_PULSEAUDIO_DIR DOES NOT EXIST."
    fi

    # SET DISPLAY OR WAYLAND_DISPLAY. IF NO DISPLAY, KILL THE SCRIPT.
    # CASE 1: DISPLAY IS SET (X11)
    if [ ! -z "${DISPLAY}" ]; then
        EchoGreen "[$(basename "$0")] \$\{DISPLAY\} IS SET."
        EchoGreen "[$(basename "$0")] SETTING VARIABLE \"DISPLAY\" AS \"${DISPLAY}\"."
        sed -i "s~${DISPLAY_LINE}~$(echo ${DISPLAY_LINE} | sed "s~\"\"~\"${DISPLAY}\"~g")~g" $1
    # CASE 2: WAYLAND_DISPLAY IS SET (WAYLAND)
    elif [ ! -z "${WAYLAND_DISPLAY}" ]; then
        EchoYellow "[$(basename "$0")] \$\{WAYLAND_DISPLAY\} IS SET."
        EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE X11 DISPLAY."
        EchoYellow "[$(basename "$0")] SETTING VARIABLE \"WAYLAND_DISPLAY\" AS \"${WAYLAND_DISPLAY}\"."
        sed -i "s~${WAYLAND_DISPLAY_LINE}~$(echo ${WAYLAND_DISPLAY_LINE} | sed "s~\"\"~\"${WAYLAND_DISPLAY}\"~g")~g" $1
    # CASE3: NO ANY DISPLAY IS SET (NON-GRAPHICAL)
    else
        EchoRed "[$(basename "$0")] ANY DISPLAY IS NOT SET."
        EchoRed "[$(basename "$0")] ARE YOU RUNNING THIS SCRIPT IN A GRAPHICAL ENVIRONMENT?"
        EChoRed "[$(basename "$0")] IF SO, PLEASE CHECK YOUR DISPLAY SETTINGS."
        exit 1
    fi

    # SET PULSEAUDIO SOCKET
    sed -i "s~${PULSEAUDIO_LINE}~$(echo ${PULSEAUDIO_LINE} | sed "s~\"\"~\"${XDG_RUNTIME_DIR}/pulse\"~g")~g" $1
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<