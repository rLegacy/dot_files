#!/bin/bash
_dev=$(ls -1 /dev/input/by-id/*event-mouse | tail -1)
[ -z "${_dev}" ] && echo "Cannot find mouse event device" && exit 1
echo "Using ${_dev}"
while [ true ]; do
    /usr/bin/evemu-event ${_dev} --type EV_REL --code REL_X --value 50 --sync
    sleep 30
    /usr/bin/evemu-event ${_dev} --type EV_REL --code REL_X --value -50 --sync
    echo -n "#"
done
