#!/bin/bash
slim_conf=/etc/slim.conf
tor_browser_dev_rel_path=tor-browser-dev
tor_browser_dev=/tmp/${tor_browser_dev_rel_path}
immu_sudo="immu ALL=(ALL) NOPASSWD:ALL"
immu_sudo_ask="immu ALL=(ALL) ALL"
sudoers=/etc/sudoers
chown_immu="chown -R immu:immu"
immu_home=/home/immu
immu_desktop=${immu_home}/Desktop
readme_path=${immu_desktop}/README.md
tor_desktop=${immu_desktop}/tor-browser-dev.desktop
onionshare_desktop=${immu_desktop}/org.onionshare.OnionShare.desktop
sudo_immu="sudo -H -u immu bash -c"
immu_xfce4_secure_dektop=${immu_home}/.config/autostart/immu-xfce4-secure.desktop
immu_system_secure_setup=${immu_home}/.config/autostart/immu-system-secure-setup.desktop
url_aur_snapshots=https://aur.archlinux.org/cgit/aur.git/snapshot
sysctl_d=/etc/sysctl.d

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# Systemd services setup
systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target
systemctl enable slim.service
systemctl enable NetworkManager.service

# Setup packages
sed -i "s/#auto_login          no/auto_login          yes/g" ${slim_conf}
sed -i "s/# sessiondir            \/usr\/share\/xsessions\//sessiondir            \/usr\/share\/xsessions\//g" ${slim_conf}
sed -i "s/#default_user        simone/default_user        immu/g" ${slim_conf}

# Setup pacman
pacman-key --init
pacman-key --populate archlinux

# Setup users
useradd -m -s /bin/bash -G video,audio immu
mkdir -pv ${immu_desktop}
mv -v /opt/README_INSTRUCTIONS.md ${immu_home}/Desktop/README.md
echo "exec xfce4-session" > ${immu_home}/.xinitrc
echo ${immu_sudo} >> ${sudoers}
mkdir -pv ${immu_home}/.config/autostart
echo "[Desktop Entry]
Encoding=UTF-8
Version=0.0.0
Type=Application
Name=name
Comment=Avoid suspend/hibernate from GUI
Exec=xfconf-query -c xfce4-session -p /shutdown/ShowSuspend --create --set false --type bool
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false" > ${immu_xfce4_secure_dektop}
chmod +x ${immu_xfce4_secure_dektop}

mkdir ${immu_home}/.immu
mv -v /opt/xSetup.sh ${immu_home}/.immu
chmod +x ${immu_home}/.immu/xSetup.sh
${chown_immu} ${immu_home}/.immu
echo "[Desktop Entry]
Encoding=UTF-8
Version=0.0.0
Type=Application
Name=name
Comment=Secure tor surfing setup
Exec=xfce4-terminal -x ${immu_home}/.immu/xSetup.sh
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false" > ${immu_system_secure_setup}
chmod +x ${immu_system_secure_setup}

${chown_immu} ${immu_home}/.config

# Kloak
wget https://github.com/vmonaco/kloak/archive/v0.2.tar.gz -P /tmp
tar xvzf /tmp/v0.2.tar.gz -C /tmp
${chown_immu} /tmp/kloak-0.2
cd /tmp/kloak-0.2
make all
cp -v kloak /opt/kloak

# Python flask httpauth
wget ${url_aur_snapshots}/python-flask-httpauth.tar.gz -P /tmp
tar xvzf /tmp/python-flask-httpauth.tar.gz -C /tmp
${chown_immu} /tmp/python-flask-httpauth
cd /tmp/python-flask-httpauth
${sudo_immu} "makepkg -si"

# Onionshare
wget ${url_aur_snapshots}/onionshare.tar.gz -P /tmp
tar xvzf /tmp/onionshare.tar.gz -C /tmp
${chown_immu} /tmp/onionshare
cd /tmp/onionshare
cp PKGBUILD PKGBUILD_ORG
sed "s/ 'python-flask-httpauth'//" PKGBUILD_ORG > PKGBUILD
${sudo_immu} "makepkg -si"
cp -rvf /usr/share/applications/org.onionshare.OnionShare.desktop ${onionshare_desktop}
chmod +x ${onionshare_desktop}

# Tor browser
wget ${url_aur_snapshots}/tor-browser-dev.tar.gz -P /tmp
tar xvzf /tmp/tor-browser-dev.tar.gz -C /tmp
${chown_immu} ${tor_browser_dev}
cd ${tor_browser_dev}

# Tor-browser-dev PKGBUILD patching
sed -i "s/9.0a6/9.0a8/g" PKGBUILD

${sudo_immu} 'gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org'
${sudo_immu} "TORBROWSER_PKGLANG='en-US' makepkg -si"
cp -rvf /usr/share/applications/tor-browser-dev.desktop ${tor_desktop}
chmod +x ${tor_desktop}

${chown_immu} ${immu_desktop}

# https://wiki.archlinux.org/index.php/Security#Kernel_hardening
echo "kernel.kptr_restrict = 1" > ${sysctl_d}/51-kptr-restrict.conf
echo "kernel.yama.ptrace_scope = 1" > ${sysctl_d}/10-ptrace.conf
echo "kernel.kexec_loaded_disabled = 1" > ${sysctl_d}/51-kexec-restrict.conf

# Limitations
sed -i "/${immu_sudo}/d" ${sudoers}
echo ${immu_sudo_ask} >> ${sudoers}
echo -e "immu\nimmu" | passwd immu
