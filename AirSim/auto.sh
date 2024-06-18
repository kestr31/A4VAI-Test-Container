#!/bin/bash

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


# FUNCTION TO PRINT A LINE OF BOXLINES
# >>>-------------------------------------------------------------
EchoBoxLine(){
    echo $(printf '%.s─' $(seq 1 $(tput cols)))
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



# MAIN SCRIPT
# >>>-------------------------------------------------------------

# CHECK IF DIRECTORY binary EXISTS
if [ ! -d /home/ue4/workspace/binary ]; then
    EchoRed "[$(basename "$0")] DIRECTORY binary DOES NOT EXIST. PLEASE CHECK IF THE DIRECTORY EXISTS."
    exit 1
else
    EchoGreen "[$(basename "$0")] DIRECTORY binary EXISTS."
    
    # CHECK IF .sh FILE EIXSTS
    if [ ! -f /home/ue4/workspace/binary/*.sh ]; then
        EchoRed "[$(basename "$0")] .sh FILE DOES NOT EXIST. KILLING THE SCRIPT."
        exit 1
    else
        EchoGreen "[$(basename "$0")] .sh FILE EXISTS."
        
        # GET NAME OF .sh FILE
        SH_FILE=$(ls /home/ue4/workspace/binary/*.sh)

        # CHECK IF SH FILE IS NOT AN ARRAY
        if [ $(echo $SH_FILE | wc -w) -gt 1 ]; then
            EchoRed "[$(basename "$0")] THERE ARE MORE THAN ONE .sh FILE. KILLING THE SCRIPT."
            EchoRed "[$(basename "$0")] PLEASE MAKE SURE THERE IS ONLY ONE .sh FILE IN THE BINARY DIRECTORY."
            exit 1
        else
            EchoGreen "[$(basename "$0")] TARGET .sh FILE: ${SH_FILE}"
            
            # CHECK IF THE .sh FILE IS EXECUTABLE
            if [ ! -x ${SH_FILE} ]; then
                EchoRed "[$(basename "$0")] ${SH_FILE} IS NOT EXECUTABLE. KILLING THE SCRIPT."
                EchoRed "[$(basename "$0")] PLEASE MAKE SURE ${SH_FILE} IS EXECUTABLE."
                exit 1
            else
                EchoGreen "[$(basename "$0")] ${SH_FILE} IS EXECUTABLE."
                EchoGreen "[$(basename "$0")] RUNNING ${SH_FILE}..."

                # RUN THE .sh FILE
                ${SH_FILE}
            fi
        fi
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<