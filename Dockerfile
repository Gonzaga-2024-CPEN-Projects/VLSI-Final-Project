FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run

COPY $QUARTUS /$QUARTUS

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

# # create a normal user so we're not running as root
# RUN export uid=1000 gid=1000 && \
#     mkdir -p /home/developer && \
#     echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
#     echo "developer:x:${uid}:" >> /etc/group && \
#     echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#     chmod 0440 /etc/sudoers.d/developer && \
#     chown ${uid}:${gid} -R /home/developer


# # groupadd -g 999 developer && useradd -u 999 -g developer -G sudo -m -s /bin/bash developer && \
# # RUN  useradd -u 999 -g developer -G sudo -m -s /bin/bash developer 
# RUN  sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'
# RUN   sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'
# RUN   sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g'
# RUN   echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# RUN   echo "Customized the sudoers file for passwordless access to the developer user!" 
# RUN   echo "developer user:";  su - developer -c id


USER root
ENV HOME /home/root
RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /home/root/altera_lite --accept_eula 1
RUN sudo apt install -y wget
RUN sudo apt-get -y install make
RUN sudo apt-get install -y zlib1g-dev
RUN sudo apt-get -y install libtool
RUN  wget http://archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng_1.2.54.orig.tar.xz
RUN tar xvf  libpng_1.2.54.orig.tar.xz 


RUN cd libpng-1.2.54 && \
   ./autogen.sh && \
   ./configure && \ 
    make -j8 && \
    sudo make install && \
    sudo ldconfig
# RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /home/root/altera_lite --accept_eula 1
    # sudo rm -r /$QUARTUS #****Nick commented this out becasue it failed
# run from xterm to capture any stdio logging (not sure there is any, but can't hurt)
# CMD xterm -e "/home/root/altera_lite/quartus/bin/quartus --64bit"
CMD xterm -e "sudo /home/root/altera_lite/quartus/bin/quartus"
 