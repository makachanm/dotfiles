## Nix (`apply.sh`)

| | |
| --- | --- |
| `udev/*.rules` | `/etc/udev/rules.d/` |
| keyd | `/etc/keyd/default.conf` |
| sddm | `/etc/sddm.conf.d/10-voidsddm.conf` |
| tailscale | `tailscaled.service`, `/usr/local/bin/tailscale` |

## Files

| | |
| --- | --- |
| `repos/*.repo` | `/etc/yum.repos.d/` |
| `scripts/plymouth-nologo.sh` | Removes Plymouth Fedora Logo |
| `scripts/nix-selinux.sh` | SELinux labels for the Nix store |
| `grub` | `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg` |
| `voidsddm/` | `/usr/share/sddm/themes/voidsddm` (submodule: `git submodule update --init`) |

`packages.txt`: COPR + RPM
