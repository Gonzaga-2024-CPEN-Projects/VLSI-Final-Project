# libpng12 included in 16.04 but not in 18.04, so we use 16.04 for convenience
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run
ARG CYCLONE=cyclone-18.1.0.625.qdz

COPY $QUARTUS /$QUARTUS
COPY $CYCLONE /$CYCLONE

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


# create a normal user so we're not running as root
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/boris && \
    echo "boris:x:${uid}:${gid}:boris,,,:/home/boris:/bin/bash" >> /etc/passwd && \
    echo "boris:x:${uid}:" >> /etc/group && \
    echo "boris ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/boris && \
    chmod 0440 /etc/sudoers.d/boris && \
    chown ${uid}:${gid} -R /home/boris

# switch to user so it installs from the user's context
# install quartus as the user (not root)
RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /home/boris/altera_lite --accept_eula 1
RUN sudo rm -f /$QUARTUS
RUN sudo rm -f /$CYCLONE

RUN mkdir /home/boris/DSD_Designs
RUN sudo chmod 777 /home/boris/DSD_Designs


ARG START_SH=scripts/cmds_on_run.sh
COPY $START_SH /cmds_on_run.sh
RUN sudo chmod a+x cmds_on_run.sh

USER boris
ENV HOME /home/boris

# container entry point.
CMD ./cmds_on_run.sh
