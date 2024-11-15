# event_demo

## demo script
```
sh build.sh
sh run.sh
```

## interactive shell
```
xhost +
docker run -it --privileged -e DISPLAY -v /dev/bus/usb:/deb/bus/usb -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /home/${USER}/.Xauthority:/home/${USER}/.Xauthority --rm --ipc=host --net=host --gpus all --name event_demo metavision
metavision_generic_tracking
```
