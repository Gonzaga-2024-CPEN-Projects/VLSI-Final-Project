# A script that goes through the steps to build the Digital System Designs
# Docker Container...


## This will pass the usb blaster through to the docker container
echo "Creating usb-blaster rules file..."
sudo touch /etc/udev/rules.d/51-usbblaster.rules
sudo mv usb_rules.txt /etc/udev/rules.d/51-usbblaster.rules
sudo udevadm control --reload-rules

# Create the shared folder for the container
mkdir -p $HOME/DSD_Designs
# We need to make sure that this dir is rwx or we won't 
# be able to do anything with it on our system or the docker.
sudo chmod 777 $HOME/DSD_Designs

docker build -t quartus18 .