## `apply.sh`

Runs `default.nix` as root. Safe to run again.

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

## Files

| | |
| --- | --- |
| `scripts/plymouth-nologo.sh` | Removes Plymouth Fedora Logo |
| `scripts/nix-selinux.sh` | SELinux labels for the Nix store |
