# Plasma raw config backup

Snapshot of the live `~/.config/*` KDE Plasma files, taken manually when
settings are tweaked outside of `home/kde.nix`. **Not applied by
home-manager** — these are reference only, so the declarative state in
`home/kde.nix` can be diffed/updated against them by hand.

Update with:

```sh
cp ~/.config/{kwinrc,plasmashellrc,plasmarc,plasma-localerc,kdeglobals,kwinoutputconfig.json} home/backup/plasma/
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc home/backup/plasma/
chmod 600 home/backup/plasma/plasma-org.kde.plasma.desktop-appletsrc home/backup/plasma/plasmashellrc home/backup/plasma/plasmarc home/backup/plasma/plasma-localerc
```

Contains machine-specific noise (applet instance IDs, per-monitor tile
geometry, weather-widget notification timestamps) that doesn't belong in
`kde.nix` — only pull over settings that represent an intentional change.
