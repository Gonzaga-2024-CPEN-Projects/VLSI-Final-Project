
# libpng12 included in 16.04 but not in 18.04, so we use 16.04 for convenience
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run
ARG CYCLONE=cyclone-18.1.0.625.qdz

COPY $QUARTUS /$QUARTUS
COPY $CYCLONE /$CYCLONE




# Install Modelsim

USER root
ENV HOME /home/root
RUN apt-get update
RUN apt-get install sudo
RUN sudo apt install -y wget

# create a normal user so we're not running as root
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/boris && \
    echo "boris:x:${uid}:${gid}:boris,,,:/home/boris:/bin/bash" >> /etc/passwd && \
    echo "boris:x:${uid}:" >> /etc/group && \
    echo "boris ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/boris && \
    chmod 0440 /etc/sudoers.d/boris && \
    chown ${uid}:${gid} -R /home/boris

ENV HOME /home/boris

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
WORKDIR /home/boris/
RUN wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2
RUN tar -xjvf freetype-2.10.0.tar.bz2
WORKDIR /home/boris/freetype-2.10.0
RUN ./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
RUN make -j$(nproc)


# WORKDIR /home/boris
WORKDIR /

ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run
COPY $MODELSIM /$MODELSIM

#  RUN wget http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/ModelSimSetup-13.1.0.162.run
RUN chmod +x ModelSimSetup-18.1.0.625-linux.run
RUN sudo ./ModelSimSetup-18.1.0.625-linux.run --mode unattended --installdir /home/boris/intelFPGA/18.1 --accept_eula 1


# # RUN  cd /root/altera/13.1/modelsim_ase &&\
# WORKDIR /root/intelFPGA/18.1/modelsim_ase
WORKDIR /home/boris/intelFPGA/18.1/modelsim_ase
RUN  cp ./vco ./vco_bkp  &&\
     sed -i -e 's/vco="linux_rh60" ;;/vco="linux" ;;/g' ./vco   &&\
     sed -i -e 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:=-"32"/g' ./vco   &&\
     sed -i -e "/dir=`dirname $arg0`/a export LD_LIBRARY_PATH=\${dir}/lib32" ./vco > /dev/null 2>&1

# # ENV HOME /opt/modelsim/modelsim_ase
RUN sudo mkdir lib32
RUN sudo cp ~/freetype-2.10.0/objs/.libs/libfreetype.so* ./lib32



# End install modelsim

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
                           xterm:amd64 && \
    chmod 755 /$QUARTUS
    
RUN sudo apt install -y wget
RUN sudo apt-get -y install make
RUN sudo apt-get install -y zlib1g-dev
RUN sudo apt-get -y install libtool
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng_1.2.54.orig.tar.xz
RUN tar xvf  libpng_1.2.54.orig.tar.xz 
    
RUN apt-get update
RUN apt-get install -y vim

RUN cd libpng-1.2.54 && \
    ./autogen.sh && \
    ./configure && \ 
    make -j8 && \
    sudo make install && \
    sudo ldconfig


# switch to user so it installs from the user's context
# install quartus as the user (not root)
RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /home/boris/altera_lite --accept_eula 1
RUN sudo rm -f /$QUARTUS
RUN sudo rm -f /$CYCLONE

# Install gHDL
# RUN sudo apt install gnat-10
# Following this tutorial
# https://ghdl.github.io/ghdl/quick_start/simulation/heartbeat/index.html

WORKDIR /home/boris
RUN sudo apt install -y git make gnat zlib1g-dev
RUN git clone https://github.com/ghdl/ghdl
WORKDIR /home/boris/ghdl
RUN ./configure --prefix=/usr/local
RUN make
RUN sudo make install


# Install gtkwave
# *************************Need to download gtkwave file: https://sourceforge.net/projects/gtkwave/
# How it was tested: cd into ghdl folder.
# ghdl -a ../DSD_Designs/Heartbeat/heartbeat.vhdl 
# ghdl -e heartbeat
# ghdl -r heartbeat --wave=wave.ghw (manually terminal with ctl-C)
# gtkwave wave.ghw
WORKDIR /home/boris/
ARG GTKWAVE=gtkwave-gtk3-3.3.116
COPY $GTKWAVE /$GTKWAVE
WORKDIR /gtkwave-gtk3-3.3.116
RUN apt-get install -y pkg-config tcl-dev
RUN apt-get install -y tk-dev
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y gperf
RUN apt-get install -y libbz2-dev

RUN ./configure
RUN make 
RUN make install


# Install Icarus
# Following this tutorial: https://medium.com/@emkboruett/installing-icarus-verilog-and-gtkwave-on-ubuntu-for-verilog-simulation-d6d31eee2096
RUN  apt install -y iverilog




RUN mkdir /home/boris/DSD_Designs
RUN sudo chmod 777 /home/boris/DSD_Designs

WORKDIR /
ARG START_SH=scripts/cmds_on_run.sh
COPY $START_SH /cmds_on_run.sh
RUN sudo chmod a+x cmds_on_run.sh

RUN usermod -aG sudo boris
# USER boris
ENV HOME /home/boris

# container entry point.
CMD ./cmds_on_run.sh
# CMD xterm
