# dotfiles

My KDE + Fedora settings. `system/` installs, `home/` configures. They are separate Nix flakes.

```sh
sudo dnf install nix nix-daemon
sudo sh system/scripts/nix-selinux.sh
system/apply.sh
home/apply.sh
```

## `system/apply.sh`

Runs `system/default.nix` as root. Safe to run again.

| | |
| --- | --- |
| dnf | RPM Fusion, COPR, `repos/*.repo`, packages |
| tailscale | official installer |
| `udev/*.rules` | `/etc/udev/rules.d/` |
| keyd | `/etc/keyd/default.conf` |
| sddm | `/etc/sddm.conf.d/10-voidsddm.conf`, voidsddm theme |
| `grub` | `/etc/default/grub`, `grub2-mkconfig` when changed |
| herdr, claude, opencode, typst, zinit | as the user, when missing |
| Flatpak | user installation, unlisted apps removed |

## `home/apply.sh`

home-manager with plasma-manager: KDE, fonts, kime, zsh, vim, herdr and Flatpak settings.

## Other scripts

| | |
| --- | --- |
| `system/scripts/plymouth-nologo.sh` | Removes Plymouth Fedora Logo |
| `system/scripts/nix-selinux.sh` | SELinux labels for the Nix store |
