


FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

# ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run

COPY $QUARTUS /$QUARTUS


   

USER root
ENV HOME /home/root
RUN apt-get update
RUN apt-get install sudo
RUN sudo apt install -y wget


ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run
COPY $MODELSIM /$MODELSIM
#  RUN wget http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/ModelSimSetup-13.1.0.162.run
RUN chmod +x ModelSimSetup-18.1.0.625-linux.run

RUN sudo dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -y -qq install apt-utils sudo && \
    apt-get -y -qq install locales && locale-gen en_US.UTF-8 && \
    apt-get -y -qq install software-properties-common \
                           libglib2.0-0:amd64 \
                           libfreetype6:amd64 \
                           libsm6:amd64 \
                           libxrender1:amd64 \
                           libfontconfig1:amd64 \
                           libxext6:amd64 \
                                # libpng12-0:amd64 \
                           xterm:amd64 
RUN apt-get -y install build-essential


RUN apt-get -y install gcc-multilib g++-multilib lib32z1 lib32stdc++6 lib32gcc-s1 expat:i386 fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 libgtk-3-0:i386 libcanberra0:i386 libpng16-16:i386 libice6:i386 libsm6:i386 libncurses5:i386 zlib1g:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386
WORKDIR /home/root/
RUN wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2
RUN tar -xjvf freetype-2.10.0.tar.bz2
WORKDIR /home/root/freetype-2.10.0
RUN ./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
RUN make -j$(nproc)


WORKDIR /
RUN sudo ./ModelSimSetup-18.1.0.625-linux.run --mode unattended --accept_eula 1


# # RUN  cd /root/altera/13.1/modelsim_ase &&\
WORKDIR /root/intelFPGA/18.1/modelsim_ase
RUN  cp ./vco ./vco_bkp  &&\
     sed -i -e 's/vco="linux_rh60" ;;/vco="linux" ;;/g' ./vco   &&\
     sed -i -e 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:=-"32"/g' ./vco   &&\
     sed -i -e "/dir=`dirname $arg0`/a export LD_LIBRARY_PATH=\${dir}/lib32" ./vco > /dev/null 2>&1

# # ENV HOME /opt/modelsim/modelsim_ase
RUN sudo mkdir lib32
RUN sudo cp ~/freetype-2.10.0/objs/.libs/libfreetype.so* ./lib32

CMD xterm







# FROM gitlab-registry.cern.ch/ecalvo/ci-hdl/ubuntu_base:latest
# # MAINTAINER Eva Calvo <eva.calvo.giraldo@cern.ch>

# # This file is the docker script file to build a container with modelSim
# # to be used in a continuous integration workflow
# #
# # =-=-=-=-    Requirements   =-=-=-=-=- 
# # - In order for this script to work, the user needs to have in the host building the 
# # docker image at the same folder than this docker script the ModelSim installer file. 
# # Ex: ModelSimSetup-17.1.0.590-linux.run or any other version. 
# # This file has not been added to the repo for space reasons, but can be freely download
# # from altera website. Modify the name of the version into the script accordingly.
# #
# # - The following docker image is build on top of another docker image stored in the same
# # repository : ubuntu_base. This docker contains an Ubuntu 16.04 OS and the libraries 
# # required by Quartus and ModelSim to work + some other utilities. Check the docker script 
# # file of the ubunutu_base docker image for more details.
# #
# # - Additionally, for the time being, some altera libraries have been copied manually 
# # from the host to the docker image into the folder /home/developer/intelFPGA/17.1/quartus/
# #
# # =-=-=-=-    Instructions    =-=-=-=-     
# # To build the docker image use the following command:
# # docker build -f ./Dockerfile_ModelSim . --network=host -t modelsim_altera_17-1
# #
# # To interactively run the image (for debugging purposes):
# # docker run -it --rm --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v /etc/machine-id:/etc/machine-id modelsim_altera_17-1

# # You should download from altera website the Modelsim installer file and place it in the same folder than this docker file
# # The following line copy local the file to the docker image
# COPY ModelSimSetup-13.1.0.162.run   /tmp/

# # Change access rights and ownership for developer user
# RUN cd /tmp && \
#     chmod +x *.run && \
#     chmod +r * &&\
#     mkdir -p /home/developer/intelFPGA/17.1/modelsim_ase &&\
#     chown -R developer. /home/developer/ &&\
#     chown -R developer. /tmp/

# # Install ModelSim as developer user
# USER developer
# RUN /tmp/ModelSimSetup-13.1.0.162.run --mode unattended 
# # --accept_eula 1

# # Remove the installer file, to make the docker smaller
# USER root
# # RUN rm /tmp/ModelSimSetup-13.1.0.162.run

# # The following command is maybe not required: the idea is to copy the altera libraries
# # into the docker image, in case the user needs them for his/her simulation. 
# # The user needs to copy the quartus/libraries folder into the same folder than this
# # docker script for this line to work.
# # COPY quartus/  /home/developer/intelFPGA/17.1/quartus/

# # Add to the PATH the modelSim folder.
# RUN  echo "PATH=$PATH:./:/home/developer/intelFPGA/17.1/modelsim_ase:/home/developer/intelFPGA/17.1/modelsim_ase/bin" >> /home/developer/.bashrc &&\
#      cd /home/developer/intelFPGA/17.1/modelsim_ase/    &&\
# # We need to correct some lines from Quartus modelsim vco file:
#      cp ./vco ./vco_bkp  &&\
#      sed -i -e 's/vco="linux_rh60" ;;/vco="linux" ;;/g' ./vco   &&\
#      sed -i -e 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:=-"32"/g' ./vco   &&\
#      sed -i -e "/dir=`dirname $arg0`/a export LD_LIBRARY_PATH=\${dir}/lib32" ./vco > /dev/null 2>&1

# # Setup some environment variables
# USER developer
# ENV    ALTERAPATH=/home/developer/intelFPGA/17.1                       \
#        QUARTUS_64BIT=1                                              














# FROM ubuntu:22.04

# ENV DEBIAN_FRONTEND noninteractive

# # ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run

# # COPY $QUARTUS /$QUARTUS


   

# USER root
# ENV HOME /home/root
# RUN apt-get update
# RUN apt-get install sudo
# RUN sudo apt install -y wget



# RUN sudo dpkg --add-architecture i386

# RUN apt-get update && \
#     apt-get -y -qq install apt-utils sudo && \
#     apt-get -y -qq install locales && locale-gen en_US.UTF-8 && \
#     apt-get -y -qq install software-properties-common \
#                            libglib2.0-0:amd64 \
#                            libfreetype6:amd64 \
#                            libsm6:amd64 \
#                            libxrender1:amd64 \
#                            libfontconfig1:amd64 \
#                            libxext6:amd64 \
#                                 # libpng12-0:amd64 \
#                            xterm:amd64 
# RUN apt-get -y install build-essential
# RUN apt-get -y install gcc-multilib g++-multilib lib32z1 lib32stdc++6 lib32gcc-s1 expat:i386 fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 libgtk-3-0:i386 libcanberra0:i386 libpng16-16:i386 libice6:i386 libsm6:i386 libncurses5:i386 zlib1g:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386
# WORKDIR /home/root/
# RUN wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2
# RUN tar -xjvf freetype-2.10.0.tar.bz2
# WORKDIR /home/root/freetype-2.10.0
# RUN ./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
# RUN make -j$(nproc)


# WORKDIR /
# ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run
# COPY $MODELSIM /$MODELSIM
# #  RUN wget http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/ModelSimSetup-13.1.0.162.run
# RUN chmod +x ModelSimSetup-18.1.0.625-linux.run


# WORKDIR /
# RUN sudo ./ModelSimSetup-18.1.0.625-linux.run --mode unattended --accept_eula 1

# WORKDIR /root/intelFPGA/18.1/modelsim_ase
# RUN  cp ./vco ./vco_bkp  &&\
#      sed -i -e 's/vco="linux_rh60" ;;/vco="linux" ;;/g' ./vco   &&\
#      sed -i -e 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:=-"32"/g' ./vco   &&\
#      sed -i -e "/dir=`dirname $arg0`/a export LD_LIBRARY_PATH=\${dir}/lib32" ./vco > /dev/null 2>&1


# RUN sudo mkdir lib32
# RUN sudo cp ~/freetype-2.10.0/objs/.libs/libfreetype.so* ./lib32

# CMD xterm



