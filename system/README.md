## Files

| | |
| --- | --- |
| `*.rules` | `/etc/udev/rules.d/` |
| `*.repo` | `/etc/yum.repos.d/` |
| `keyd.conf` | `/etc/keyd/default.conf` |
| `grub` | `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg` |
| `sddm.conf` | `/etc/sddm.conf.d/10-void.conf` |
| `plymouth-nologo.sh` | Removes Plymouth Fedora Logo |

`packages.txt`: COPR + Flatpak+ RPM

## SDDM theme

[VoidSDDM](https://github.com/talyamm/VoidSDDM):

```sh
git clone https://github.com/talyamm/voidsddm
sudo cp -r voidsddm /usr/share/sddm/themes/void
```
