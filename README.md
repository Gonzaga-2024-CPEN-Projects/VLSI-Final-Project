What goes in the rules file:

Note: I have experienced some instances of not being
able to build the container unless Docker Desktop is
running. So make sure to start that before running
`build_container.sh`.

```shell
filename: /etc/udev/rules.d/51-usbblaster.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
```


build with:
```shell
sudo ./build_container.sh
```

Then run with:
```shell
./start_docker.sh
```
run the container: 
Open XQuartz manually
```shell
export DISPLAY=localhost:0
xhost +localhost
DISPLAY=docker.for.mac.host.internal:0 
docker run --rm -v /sys:/sys:ro -v $HOME/DSD_Designs:/home/boris/DSD_Designs \
                -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e "QT_X11_NO_MITSHM=1" \
                --privileged -v /dev/bus/usb:/dev/bus/usb quartus18 
```
Launch Quartus from within Docker: 
```shell
 sudo /home/root/altera_lite/quartus/bin/quartus
```

url: http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html
