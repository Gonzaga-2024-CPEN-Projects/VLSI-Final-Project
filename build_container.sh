# A script that goes through the steps to build the Digital System Designs
# Docker Container...

# First Download the setup files necessary for the build
echo "Downloading Quartus, Cyclone, and ModelSim files..."

filename='ModelSimSetup-18.1.0.625-linux.run'
# Don't download the file if it already exists.
test -f $filename && echo 'ModelSim.run file exists.' || wget -O ModelSimSetup-18.1.0.625-linux.run https://cdrdv2.intel.com/v1/dl/getContent/750368/750371?filename=ModelSimSetup-18.1.0.625-linux.run

filename='QuartusLiteSetup-18.1.0.625-linux.run'
# Don't download the file if it already exists.
test -f $filename && echo 'QuartusLiteSetup.run file exists.' || wget -O QuartusLiteSetup-18.1.0.625-linux.run https://cdrdv2.intel.com/v1/dl/getContent/665988/710188?filename=QuartusLiteSetup-18.1.0.625-linux.run


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

docker build -t quartus18 .