# A script that goes through the steps to build the Digital System Designs
# Docker Container...


## This will pass the usb blaster through to the docker container
echo "Creating usb-blaster rules file..."
sudo touch "/etc/udev/rules.d/51-usbblater.rules"
echo "SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"" > /etc/udev/rules.d/51-usbblater.rules
sudo sudo udevadm control --reload-rules

# Create the shared folder for the container
mkdir -p $HOME/DSD_Designs
# We need to make sure that this dir is rwx or we won't 
# be able to do anything with it on our system or the docker.
sudo chmod 777 $HOME/DSD_Designs

docker build -t quartus18 .