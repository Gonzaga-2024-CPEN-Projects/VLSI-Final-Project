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

filename=eclipse-mars2.tar.gz
test -f $filename && echo "eclipse-mars2.tar.gz file exists" || wget http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/R-4.2.2-201302041200/eclipse-SDK-4.2.2-linux-gtk-x86_64.tar.gz
mv download.php?file=%2Feclipse%2Fdownloads%2Fdrops4%2FR-4.2.2-201302041200%2Feclipse-SDK-4.2.2-linux-gtk-x86_64.tar.gz eclipse-mars2.tar.gz

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

cp scripts/bash_profile $HOME/DSD_Designs/.bash_profile
cp scripts/bashrc $HOME/DSD_Designs/.bashrc

docker build -t iflury/quartus18:version1.0 .