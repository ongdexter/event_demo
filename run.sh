#!/bin/bash

SIZE_MIN=100
SIZE_MAX=3000
FREQ=30

xhost +
docker run --privileged -e DISPLAY -v /dev/bus/usb:/deb/bus/usb -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /home/${USER}/.Xauthority:/home/${USER}/.Xauthority --rm --ipc=host --net=host --gpus all metavision metavision_generic_tracking \
    --min-size $SIZE_MIN \
    --max-size $SIZE_MAX \
    --update-frequency $FREQ