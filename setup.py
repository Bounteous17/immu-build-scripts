import sys
import os
from utils import config, consoleLog, shortConfig, resume
from tools import createFolder, executeBashCommand
from models.error import Error


def mountIso():
    os.chdir('../')
    consoleLog(
        'Mounting %s into %s' %
        (shortConfig['archIsoFileName'], config['mountIso']), 'warn')
    print(executeBashCommand('pwd'))
    executeBashCommand('mount -t iso9660 -o loop %s %s' %
                       (shortConfig['isoPath'], config['mountIso']))

    consoleLog('Copying iso files to %s folder' % (config['pathCustomIso']),
               'warn')
    _copy = executeBashCommand('cp -av %s %s' %
                               (config['mountIso'], config['pathCustomIso']))
    if type(_copy) == Error:
        sys.exit(1)


def unsquashIso():
    os.chdir(config['pathCustomIso'] + '/arch/x86_64')
    # Feel free to comment lines from there after resume option is enabled
    _unsquashfs = executeBashCommand('unsquashfs airootfs.sfs')
    if type(_unsquashfs) == Error:
        sys.exit(1)
    _cpVmlinuz = executeBashCommand(
        'cp ../boot/x86_64/vmlinuz squashfs-root/boot/vmlinuz-linux')
    if type(_cpVmlinuz) == Error:
        sys.exit(1)
    _chrootPacmanInit = executeBashCommand(
        'arch-chroot squashfs-root pacman-key --init')
    if type(_chrootPacmanInit) == Error:
        sys.exit(1)
    _chrootPacmanPop = executeBashCommand(
        'arch-chroot squashfs-root pacman-key --populate archlinux')
    if type(_chrootPacmanPop) == Error:
        sys.exit(1)
    executeBashCommand(
        'arch-chroot squashfs-root pacman -Syu --force archiso linux lxdm ttf-dejavu xfce4 base-devel'
    )
    executeBashCommand(
        'cp -fv ../../../.configs/etc/mkinitcpio.conf squashfs-root/etc/mkinitcpio.conf'
    )
    executeBashCommand('arch-chroot squashfs-root mkinitcpio -p linux')
    executeBashCommand(
        'cp -fv ../../../.configs/etc/lxdm.conf squashfs-root/etc/lxdm/lxdm.conf')
    executeBashCommand(
        'cp -fv ../../../.configs/etc/sudoers squashfs-root/etc/sudoers')
    executeBashCommand('arch-chroot squashfs-root userdel -f installer')
    executeBashCommand(
        'arch-chroot squashfs-root useradd -m -s /bin/bash installer')
    executeBashCommand(
        'git clone https://aur.archlinux.org/yay.git squashfs-root/yay')
    executeBashCommand(
        'arch-chroot squashfs-root chown -Rf installer:users /yay')
    executeBashCommand(
        'cp -fv ../../../.configs/bin/install-yay squashfs-root/bin/install-yay'
    )
    executeBashCommand('arch-chroot squashfs-root chmod +x /bin/install-yay')
    executeBashCommand(
        'arch-chroot squashfs-root chown -Rf installer:users /bin/install-yay')
    executeBashCommand(
        'arch-chroot squashfs-root sudo -u installer /bin/install-yay')
    executeBashCommand(
        'arch-chroot squashfs-root sudo -u installer gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org'
    )
    executeBashCommand(
        'arch-chroot squashfs-root sudo -u installer yay -S tor-browser')
    executeBashCommand('arch-chroot squashfs-root userdel -f installer')
    executeBashCommand(
        'cp -v ../../../.configs/bin/pkglist squashfs-root/bin/pkglist')
    executeBashCommand(
        'arch-chroot squashfs-root useradd -m -s /bin/bash -G video,audio immu')
    executeBashCommand('arch-chroot squashfs-root pkglist')
    executeBashCommand('arch-chroot squashfs-root pacman -Scc')
    executeBashCommand(
        'arch-chroot squashfs-root systemctl disable multi-user.target')
    executeBashCommand(
        'arch-chroot squashfs-root systemctl enable graphical.target')
    executeBashCommand('arch-chroot squashfs-root systemctl enable lxdm')
    executeBashCommand(
        'mv -v squashfs-root/boot/vmlinuz-linux ../boot/x86_64/vmlinuz')
    executeBashCommand(
        'mv -v squashfs-root/boot/initramfs-linux.img ../boot/x86_64/archiso.img'
    )
    executeBashCommand('rm squashfs-root/boot/initramfs-linux-fallback.img')
    executeBashCommand('mv -v squashfs-root/pkglist.txt ../pkglist.x86_64.txt')
    executeBashCommand('rm airootfs.sfs')
    executeBashCommand('mksquashfs squashfs-root airootfs.sfs')
    executeBashCommand('rm -r squashfs-root')
    executeBashCommand('sha512sum airootfs.sfs > airootfs.sha512')


def genIso():
    os.chdir('../../')
    executeBashCommand(
        "genisoimage -l -r -J -V %s -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o ../out/immu-arch-custom.iso ./"
        % (config['isoLabel']))
    # executeBashCommand(
    #     'xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -volid %s -eltorito-boot isolinux/isolinux.bin -eltorito-catalog isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -isohybrid-mbr ~/customiso/isolinux/isohdpfx.bin -output ../out/immu-arch-custom.iso ../../../'
    #     % (config['isoLabel']))
