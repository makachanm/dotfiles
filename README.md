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

System files: [system/README.md](system/README.md)
