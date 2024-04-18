What goes in the rules file:

Note: I have experienced some instances of not being
able to build the container unless Docker Desktop is
running. So make sure to start that before running
`build_container.sh`.

```shell
filename: /etc/udev/rules.d/51-usbblaster.rules
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

url: http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html