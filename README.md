# dotfiles

Fedora + KDE Plasma (KWin + Karousel).

- `home/`: home-manager + plasma-manager
- `system/`: everything else

## Home

```sh
sudo dnf install nix nix-daemon
sudo sh system/nix-selinux.sh
nix run home-manager -- switch --flake .#maka -b hm-backup
```

After that: `home-manager switch --flake .#maka`

## System

| File | Destination |
| --- | --- |
| `*.rules` | `/etc/udev/rules.d/` |
| `*.repo` | `/etc/yum.repos.d/` |
| `keyd.conf` | `/etc/keyd/default.conf` |
| `grub` | `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg` |
| `sddm.conf` | `/etc/sddm.conf.d/10-void.conf` |
| `plymouth-nologo.sh` | run with `sudo sh` |

`packages.txt` lists COPR repos, RPM Fusion, dnf packages and Flatpaks.

## SDDM theme

[VoidSDDM](https://github.com/talyamm/VoidSDDM):

```sh
git clone https://github.com/talyamm/voidsddm
sudo cp -r voidsddm /usr/share/sddm/themes/void
```
