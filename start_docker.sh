docker run --rm -v /sys:/sys:ro -v $HOME/DSD_Designs:/home/boris/DSD_Designs \
                -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e "QT_X11_NO_MITSHM=1" \
                --privileged -v /dev/bus/usb:/dev/bus/usb quartus18 