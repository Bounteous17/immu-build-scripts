# The official Immu Linux ISO builder

## Description

Immu Linux is a live Iso based on Arch Linux build scripts designed specifically for the security of anonymity while browsing on the Tor network.


## Download and verify Iso file
https://github.com/bounteous/immu-build-scripts/releases/

#### Why Immu Linux?

The objective of this live ISO is to facilitate the use to users who wish to navigate anonymously. The way to achieve this is to meet the following specifications:

- Latest versions of critical parts of the system (Kernel stable, systemd, GNU coreutils, GUI)
- System packages with the latest security patches available (Tor browser, AUR builders, Shell, Compilers, LIBs)
- Running with free software and the best hardware recognition available.
- Only strictly necessary software packages are installed
- Packages -> ~400 (Pacman) | 1 (AUR)

## Tips and features

The linux kernel image chosen by default is linux-hardened. It's a security-focused Linux kernel applying a set of hardening patches to mitigate kernel and userspace exploits. It also enables more upstream kernel hardening features than linux.
(https://wiki.archlinux.org/index.php/Kernel#Officially_supported_kernels)

The system time is set from the time that is set in the hardware of the equipment, usually from the BIOS. The **timedatectl** package is responsible for setting the date and time in the system. Be sure to **set the correct** time for your system so as not to compromise your system.
(https://wiki.archlinux.org/index.php/System_time#Hardware_clock)

Modalities such as **suspend or hibernate** the device **are disabled** from the Xfce graphical interface. In this way it is ensured that by mistake the user does not confuse the option to turn off with the rest of the modes that **can save sensitive information** of the user's current session. (https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#System_does_not_power_off_when_hibernating)

Consider that if you use the official image of the system, your **user is not added to the sudoers group**. The **root** user's **shell is disabled** and its user "immu" has **no** password or **possibility to be accessed remotely**.

The **entire file system** is mounted using **volatile** storage
(https://www.thegeekstuff.com/2008/11/overview-of-ramfs-and-tmpfs-on-linux/)

# Development

## Build ISO

You can only run it on an Arch Linux system. It is highly recommended to use it with an up to date system. (Note that this is an **alpha** version)

On Arch Linux, simply execute as a root user:
```
pacman -Syyu archiso git
```
```
git clone https://github.com/bounteous/immu-build-scripts.git
```
```
./make.sh
```
and go ahead.

The final Iso file will be generated within the "**out/**" directory.

![Screenshot_20191009_222745](https://user-images.githubusercontent.com/16175933/66517870-37bbac00-eae4-11e9-8155-ea492750e406.png)

## Get Involved

You can get in touch with the Immu Linux team. 
**Please, send us pull requests!**
