# Instructions for Windows Users:

1. To use this docker container, you need to install docker desktop and wsl
2. You can install docker desktop from the microsoft store, and instructions to install WSL are [here].

Clone the repo in a wsl terminal with:
```shell
git clone https://github.com/Gonzaga-2024-CPEN-Projects/VLSI-Final-Project.git
```

3. Once you have the repo downloaded, navigate to it and run the following.
```shell
sudo chmod a+x build_container_quick.sh
sudo ./build_container_quick.sh
```

Note: You need to have `Docker Desktop` running in the background before you attempt to
      run the build script above.

4. Now that you have build the container, you can run the container with: (you may need to use sudo)
```shell
./start_docker.sh
```

# Instructions for MacOS Users
As of May 2024, Docker does not support USB passthrough on Mac. The Docker container will work on MAC, but programming the FPGA will not since the container cannot access the USB port. To use the container on a Mac, install XQuartz: https://www.xquartz.org/  and proceed with the instructions, skipping the wsl steps.
Run these steps before starting the container:
```shell
export DISPLAY=localhost:0
xhost +localhost
DISPLAY=docker.for.mac.host.internal:0
```

To be able to use the container and program the FPGA on Mac, use a virtual machine running Ubuntu and pass the USB through to the virtual machine. Then, proceed with the rest of the instructions.  


# General Usage

## usb-passthrough
1. To flash your hardware design and software to an Altera FPGA board you'll need to pass the usb
   connections on your host machine through to wsl. **Do this before you start the container**.
In an administrator instance of powershell:
```shell
winget install usbipd
usbipd list
usbipd wsl attach --busid <id>
```

## Quartus and Modelsim
- When you start the docker container, Quartus will open and an instance of xterm will open. 
- You can use Quartus like you normally would. To make sure that your project save between
  running instances of the container make sure you store them in `/home/boris/DSD_Designs`.
- Before you envoke a script with modelsim commands in it, it might be helpful to source
  the `.bash_profile` and `.bashrc` files in the `/home/boris/DSD_Designs` dir.

## Building from scratch on Windows
- You do not need to do these steps to use the docker container, only to make modifications to it.

- To build from scratch, you need to download the files in [this repository] to the cloned repo on 
  your machine.

1. Ensure that git lfs is installed:
```shell
$ git lfs install
> Git LFS initialized.
```

2. Clone the repository:
```shell
git clone https://github.com/Gonzaga-2024-CPEN-Projects/VLSI-Final-Project.git
```

3. Start the `Docker Desktop` application.
4. In WSL, run the `build container script` and enter your sudo password when prompted:
```shell
sudo ./build_container_from_scratch.sh
```

5. Once you've built the container, you can plug the usb to the FPGA into your computer.

6. Open an Administrator instance of powershell and run (you will need to do this before
you start the container everytime to give wsl access to the usb device).
```shell
usbipd wsl list
usbipd wsl attach --busid <id>
```

5. Once the container is built, start it with the `start docker script`:
```shell
./start_docker
```

## Building from scratch on MacOS
- You do not need to do these steps to use the docker container, only to make modifications to it.
- To build from scratch, you need to download the files in [this repository] to the cloned repo on 
  your machine.
1. ... (nick)

# Errors:

- if you get the "xterm: Xt error: cannot open display" error...

```shell
xhost si:localuser:root
```

[here]:https://learn.microsoft.com/en-us/windows/wsl/install
[this repository]:https://drive.google.com/drive/folders/1c2Sim5qkLjLW3gy5qTacGj383V3qEaad?usp=sharing
