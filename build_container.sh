# A script that goes through the steps to build the Digital System Designs
# Docker Container...


## This will pass the usb blaster through to the docker container
echo "Creating usb-blaster rules file..."
sudo touch "/etc/udev/rules.d/51-usbblater.rules"
echo "SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"" > /etc/udev/rules.d/51-usbblater.rules
sudo sudo udevadm control --reload-rules

# Need these tools for mounting a shared directory
sudo apt-get install cifs-utils

docker build -t quartus18 .