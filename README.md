What goes in the rules file:
```shell
filename: /etc/udev/rules.d/51-usbblater.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
```

Then run:
```shell
sudo udevadm control --reload-rules
```

build with:
```shell
sudo docker buildx build -t q18 .
```
run the container: 
```shell
export DISPLAY=localhost:0
xhost +localhost
DISPLAY=docker.for.mac.host.internal:0 
sudo docker run --rm -v /sys:/sys:ro -v $HOME:/shared -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged -v /dev/bus/usb:/dev/bus/usb q18
```




url: http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html
