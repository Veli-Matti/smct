#!/bin/bash

# Global variables
readonly BROADCAST_ADDR='169.254.255.255'

# Functions
send() {
    local _FILE="${1}"
    local _ADDR="${2}"
    local _PORT="${3}"
    FILE_SIZE="$(wc -c < "${_FILE}")"
    
    # Use dd to avoid shell autoconversion for null in raw data
    READ_DATA_CMD="dd if=${_FILE} bs=${FILE_SIZE} count=1 status=none"
    if [ ${_ADDR} == ${BROADCAST_ADDR} ]
    then
        ${READ_DATA_CMD} | socat - "UDP4-SENDTO:${_ADDR}:${_PORT}",broadcast
    else
        ${READ_DATA_CMD} > "/dev/udp/${_ADDR}/${_PORT}"
    fi
}

# Default values

# TODO. Set input params

# Content from datafile
# SMCP_DATA_FILE='set-led-green.dat'
SMCP_DATA_FILE='get-version.dat'

ADDR=${BROADCAST_ADDR}
# ADDR='169.254.51.224'

PORT=55555

# [Options]
#     -a  Target address
#     -d  Device ID
#     -p  Port
#     -c  CommandId
#     -p  Command params ...

# Send the message
send ${SMCP_DATA_FILE} ${ADDR} ${PORT}
