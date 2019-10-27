# The official Immu Linux ISO builder

## Description

**Immu Linux** is a **live Iso** based on <a href="https://www.archlinux.org/">Arch Linux</a> build scripts designed specifically for the security of anonymity while browsing on the Tor network. 

## How it works

```
dd if=immulinux-alpha-2019.10.25-x86_64.iso of=/dev/sdX bs=4M
```

After starting your computer from the device with the Immu Linux Iso, you will have a system with the following features:

- Your system is **not** going to have the ability to **store data** on the device on which the ISO is recorded
- You will have at your fingertips the **latest versions** of all the **software packages** that have been included and are available in the stable branch of the repositories.
- **Basic functionalities** that may include other Linux-based systems have been **disabled** to **avoid storing evidences** in case of a forensic analysis.
- Any type of **proprietary software** has been **ruled out** to prevent information leaks or unknown security flaws.
- In an emergency, **simply disconnect** your device from the **power**. All the system data **was mounted in RAM**.
- At the moment the system starts, a script is executed to configure some tracking protections, such as:
    - <a href="https://www.archlinux.org/packages/community/x86_64/macchanger/">macchanger</a>
    - <a href="https://github.com/vmonaco/kloak">kloak</a>
    - <a href="https://github.com/bounteous/immu-build-scripts#tips-and-features">Read more ...</a>
    


## Download and verify Iso file
https://github.com/bounteous/immu-build-scripts/releases/

#### Why Immu Linux?

The objective of this live ISO is to facilitate the use to users who wish to navigate anonymously. The way to achieve this is to meet the following specifications:

- **Latest versions** of critical parts of the system (Kernel stable, systemd, GNU coreutils, GUI)
- System packages with the **latest security patches** available (Tor browser, AUR builders, Shell, Compilers, LIBs)
- Running with **free software** and the **best hardware recognition** available.
- **Only** strictly **necessary software** packages are installed
- **Packages** -> ~400 (Pacman) | 1 (AUR)

## Tips and features

The linux kernel image chosen by default is linux-hardened. It's a security-focused Linux kernel applying a set of hardening patches to mitigate kernel and userspace exploits. It also enables more upstream kernel hardening features than linux.
(https://wiki.archlinux.org/index.php/Kernel#Officially_supported_kernels)

The system time is set from the time that is set in the hardware of the equipment, usually from the BIOS. The **timedatectl** package is responsible for setting the date and time in the system. Be sure to **set the correct** time for your system so as not to compromise your system.
(https://wiki.archlinux.org/index.php/System_time#Hardware_clock)


During the system startup script, the <a href="https://www.archlinux.org/packages/community/x86_64/macchanger/">macchanger</a> package will be in charge of allowing us to **modify** the desired network interface **MAC address** at any time.
(https://wiki.archlinux.org/index.php/MAC_address_spoofing)

Modalities such as **suspend or hibernate** the device **are disabled** from the Xfce graphical interface. In this way it is ensured that by mistake the user does not confuse the option to turn off with the rest of the modes that **can save sensitive information** of the user's current session.
(https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#System_does_not_power_off_when_hibernating)

Consider that if you use the official image of the system, your **user is added to the sudoers group**. The **root** user's **shell is enabled** and its user "immu" has default password and no **possibility to be accessed remotely**. As soon as the system image starts, a prompt is responsible for allowing you to enter the new password for the user.

The **entire file system** is mounted using **volatile** storage.
(https://www.thegeekstuff.com/2008/11/overview-of-ramfs-and-tmpfs-on-linux/)

A privacy tool that makes **keystroke biometrics** less effective. This is accomplished by **obfuscating** the time **intervals** between key press and release events, which are typically used for identification.
(https://github.com/vmonaco/kloak)

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

![Screenshot_20191025_220943](https://user-images.githubusercontent.com/16175933/67605652-3e525080-f77f-11e9-84a6-9fad211ba66a.png)

## Get Involved

You can get in touch with the Immu Linux team. 
**Please, send us pull requests!**
