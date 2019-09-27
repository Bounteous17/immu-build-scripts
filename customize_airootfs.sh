#!/bin/bash
slim_conf=/etc/slim.conf
tor_browser_aur=/opt/tor-browser-aur
immu_sudo="immu ALL=(ALL) NOPASSWD:ALL"
sudoers=/etc/sudoers
chown_immu="chown -R immu:immu"
immu_home=/home/immu
immu_desktop=${immu_home}/Desktop
readme_path=${immu_desktop}/README.md
tor_desktop=${immu_desktop}/tor-browser.desktop
sudo_immu="sudo -H -u immu bash -c"

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
useradd -m -s /bin/bash -G wheel,video,audio immu
mkdir ${immu_desktop}
mv -v /opt/README_INSTRUCTIONS.md /home/immu/Desktop/README.md
echo "exec xfce4-session" > /home/immu/.xinitrc
echo ${immu_sudo} >> ${sudoers}

# Tor browser
${chown_immu} ${tor_browser_aur}
cd ${tor_browser_aur}
${sudo_immu} 'gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org'
${sudo_immu} 'makepkg -si'
ln -s ${tor_browser_aur}/tor-browser.desktop ${tor_desktop}
chmod +x ${tor_browser_aur}/tor-browser.desktop
${chown_immu} ${immu_desktop}

# Limitations
xfconf-query -c xfce4-session -np '/shutdown/ShowSuspend' -t 'bool' -s 'false'
xfconf-query -c xfce4-session -np '/shutdown/ShowHibernate' -t 'bool' -s 'false'
# Custom_1[3]
sed -i "/${immu_sudo}/d" ${sudoers}
chsh -s /bin/false root
# echo -e "toor\ntoor" | passwd root