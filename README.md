# dotfiles

My KDE + Fedora settings. `home/` and `system/` are separate Nix flakes.

## Nix

```sh
sudo dnf install nix nix-daemon
sudo sh system/scripts/nix-selinux.sh
```

## Home

```sh
nix run home-manager -- switch --flake ./home#maka -b hm-backup
```

After that: `home-manager switch --flake ./home#maka`

## System

```sh
system/apply.sh
```

Check `system/README.md`.
