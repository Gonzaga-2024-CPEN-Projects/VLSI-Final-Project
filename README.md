What goes in the rules file:

Note: I have experienced some instances of not being
able to build the container unless Docker Desktop is
running. So make sure to start that before running
`build_container.sh`.

```shell
filename: /etc/udev/rules.d/51-usbblaster.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
```


build with:
```shell
sudo ./build_container.sh
```

Then run with:
```shell
./start_docker.sh
```

url: http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html

# Windows Install Instructions

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
sudo ./build_container
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

# Errors:

- if you get the "xterm: Xt error: cannot open display" error...

```shell
xhost si:localuser:root
```