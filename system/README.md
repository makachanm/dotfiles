## Files

| | |
| --- | --- |
| `udev/*.rules` | `/etc/udev/rules.d/` |
| `repos/*.repo` | `/etc/yum.repos.d/` |
| `scripts/plymouth-nologo.sh` | Removes Plymouth Fedora Logo |
| `scripts/nix-selinux.sh` | SELinux labels for the Nix store |
| `keyd.conf` | `/etc/keyd/default.conf` |
| `grub` | `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg` |
| `sddm.conf` | `/etc/sddm.conf.d/10-voidsddm.conf` |
| `voidsddm/` | `/usr/share/sddm/themes/voidsddm` (submodule: `git submodule update --init`) |

`packages.txt`: COPR + Flatpak + RPM
