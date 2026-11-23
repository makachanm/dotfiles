# dotfiles

My KDE + Fedora settings. `system/` installs, `home/` configures. They are separate Nix flakes.

## Nix

```sh
sudo dnf install nix nix-daemon
sudo sh system/scripts/nix-selinux.sh
```

## System

```sh
system/apply.sh
```

## Home

```sh
nix run home-manager -- switch --flake ./home#maka -b hm-backup
```

After that: `home-manager switch --flake ./home#maka`
