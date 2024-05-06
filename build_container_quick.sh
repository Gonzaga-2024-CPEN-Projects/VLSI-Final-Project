# This script pulls the EDA tools docker image from the docker hub
# without building from scratch. It also creates a usbblaster rules
# files that is needed for usb pass-through to the docker container.

## This will pass the usb blaster through to the docker container
echo "Creating usb-blaster rules file..."
# sudo touch /etc/udev/rules.d/51-usbblaster.rules
sudo cp usb_rules.txt /etc/udev/rules.d/51-usbblaster.rules
sudo udevadm control --reload-rules

# Create the shared folder for the container
mkdir -p $HOME/DSD_Designs
# We need to make sure that this dir is rwx or we won't 
# be able to do anything with it on our system or the docker.
sudo chmod 777 $HOME/DSD_Designs

cp scripts/bash_profile.txt $HOME/DSD_Designs/.bash_profile
cp scripts/bashrc.txt $HOME/DSD_Designs/.bashrc

echo "pulling the image from docker"
docker pull "iflury/quartus18:version1.0"
