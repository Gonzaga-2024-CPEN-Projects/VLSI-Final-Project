What goes in the rules file:
```shell
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