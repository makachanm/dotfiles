# dotfiles

My KDE + Fedora settings.

## Home

```sh
sudo dnf install nix nix-daemon
sudo sh system/scripts/nix-selinux.sh
nix run home-manager -- switch --flake .#maka -b hm-backup
```

After that: `home-manager switch --flake .#maka`

## System

Check `system/README.md`.