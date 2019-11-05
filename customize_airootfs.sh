#!/bin/bash
slim_conf=/etc/slim.conf
tor_browser_dev_rel_path=tor-browser-dev
tor_browser_dev=/tmp/${tor_browser_dev_rel_path}
sudo_immu_all="immu ALL=(ALL)"
immu_sudo="${sudo_immu_all} NOPASSWD:ALL"
immu_sudo_ask="${sudo_immu_all} ALL"
sudoers=/etc/sudoers
chown_immu="chown -R immu:immu"
immu_home=/home/immu
immu_desktop=${immu_home}/Desktop
readme_path=${immu_desktop}/README.md
tor_desktop=${immu_desktop}/tor-browser-dev.desktop
onionshare_desktop=${immu_desktop}/org.onionshare.OnionShare.desktop
sudo_immu="sudo -H -u immu bash -c"
immu_home_custom=${immu_home}/.immu
immu_home_custom_xSetup=${immu_home_custom}/xSetup.sh
immu_home_config=${immu_home}/.config
immu_home_autostart=${immu_home_config}/autostart
immu_xfce4_secure_dektop=${immu_home_autostart}/immu-xfce4-secure.desktop
immu_system_secure_setup=${immu_home_autostart}/immu-system-secure-setup.desktop
url_aur_https=https://aur.archlinux.org
sysctl_d=/etc/sysctl.d
makepkg="makepkg -si"
untar_gz="tar xvf"
sysinit="systemctl"
systemctl_enable="${sysinit} enable"
systemctl_set_default="${sysinit} set-default"
sed_replace="sed -i"
yay_bin="/tmp/yay/pkg/yay/usr/bin/yay"
yay_install="${yay_bin} -S"
yay_edit_install="${yay_install} --editmenu"

set -e -u

${sed_replace} 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root

${sed_replace} "s/#Server/Server/g" /etc/pacman.d/mirrorlist
${sed_replace} 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

${sed_replace} 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
${sed_replace} 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
${sed_replace} 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# Systemd services setup
${systemctl_enable} pacman-init.service choose-mirror.service slim.service NetworkManager.service ntpd.service
${systemctl_set_default} graphical.target

# Setup packages
${sed_replace} "s/#auto_login          no/auto_login          yes/g" ${slim_conf}
${sed_replace} "s/# sessiondir            \/usr\/share\/xsessions\//sessiondir            \/usr\/share\/xsessions\//g" ${slim_conf}
${sed_replace} "s/#default_user        simone/default_user        immu/g" ${slim_conf}

# Setup pacman
pacman-key --init
pacman-key --populate archlinux

# Setup users env
useradd -m -s /bin/bash -G video,audio immu
mkdir -pv ${immu_desktop}
mv -v /opt/README_INSTRUCTIONS.md ${immu_home}/Desktop/README.md
echo "exec xfce4-session" > ${immu_home}/.xinitrc
echo ${immu_sudo} >> ${sudoers}
mkdir -pv ${immu_home_autostart}

mkdir ${immu_home_custom}
mv -v /opt/xSetup.sh ${immu_home_custom}
${chown_immu} ${immu_home_custom}

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

echo "[Desktop Entry]
Encoding=UTF-8
Version=0.0.0
Type=Application
Name=name
Comment=Secure tor surfing setup
Exec=xfce4-terminal -x ${immu_home_custom_xSetup}
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false" > ${immu_system_secure_setup}
chmod +x ${immu_system_secure_setup}
chmod +x ${immu_home_custom_xSetup}

${chown_immu} ${immu_home_config}

cd /tmp
${sudo_immu} "git clone ${url_aur_https}/yay.git"
cd yay
${sudo_immu} ${makepkg}

${sudo_immu} "${yay_install} mat2 onionshare"

${sudo_immu} 'gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org'
${sudo_immu} "${yay_edit_install} tor-browser-dev"

# Kloak
wget https://github.com/vmonaco/kloak/archive/v0.2.tar.gz -P /tmp
${untar_gz} /tmp/v0.2.tar.gz -C /tmp
${chown_immu} /tmp/kloak-0.2
cd /tmp/kloak-0.2
make all
cp -v kloak /opt/kloak

# Onionshare
cp -rvf /usr/share/applications/org.onionshare.OnionShare.desktop ${onionshare_desktop}
chmod +x ${onionshare_desktop}

# Tor browser
cp -rvf /usr/share/applications/tor-browser-dev.desktop ${tor_desktop}
chmod +x ${tor_desktop}

${chown_immu} ${immu_desktop}

# https://wiki.archlinux.org/index.php/Security#Kernel_hardening
echo "kernel.kptr_restrict = 1" > ${sysctl_d}/51-kptr-restrict.conf
echo "kernel.yama.ptrace_scope = 1" > ${sysctl_d}/10-ptrace.conf
echo "kernel.kexec_loaded_disabled = 1" > ${sysctl_d}/51-kexec-restrict.conf

${yay_bin} -Scc

# Limitations
${sed_replace} "s/${immu_sudo}/${immu_sudo_ask}/" ${sudoers}
echo -e "immu\nimmu" | passwd immu
