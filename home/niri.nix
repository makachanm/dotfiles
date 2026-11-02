{ lib, ... }:
let
  copied = {
    ".config/niri/config.kdl" = ./config/niri/config.kdl;
    ".config/niri/focus-ring.kdl" = ./config/niri/focus-ring.kdl;
    ".config/niri/noctalia.kdl" = ./config/niri/noctalia.kdl;
    ".config/noctalia/settings.toml" = ./config/noctalia/settings.toml;
    ".config/pcmanfm-qt/default/settings.conf" = ./config/pcmanfm-qt/settings.conf;
  };
in
{
  home.file = {
    ".config/niri/scripts/ws-cycle".source = ./config/niri/scripts/ws-cycle;
    ".config/noctalia/palettes/Mono.json".source = ./config/noctalia/palettes/Mono.json;
    ".config/xdg-desktop-portal/niri-portals.conf".source = ./config/desktop/niri-portals.conf;
    ".local/share/applications/dev.noctalia.Noctalia.desktop".source = ./config/applications/dev.noctalia.Noctalia.desktop;
    ".local/share/applications/qterminal.desktop".source = ./config/applications/qterminal.desktop;
    ".local/share/applications/qterminal-drop.desktop".source = ./config/applications/qterminal-drop.desktop;
  };

  home.activation.copyNiriConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (
      lib.mapAttrsToList (dest: src: ''
        run install -Dm644 ${src} "$HOME/${dest}"
      '') copied
    )
  );
}
