{ pkgs, ... }:
let
  karousel = pkgs.fetchzip {
    url = "https://github.com/peterfajdiga/karousel/releases/download/v0.18/karousel_0_18.tar.gz";
    hash = "sha256-BNINtARJ7IVZB2cUi9j5U2d+RNAdFvcGr6x8c8YR4Hk=";
    stripRoot = false;
  };
in
{
  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      iconTheme = "Papirus-Dark";
      wallpaper = ./assets/wallpaper + "/PIA26702~orig.png";
    };

    fonts = {
      general = { family = "IBM Plex Sans KR"; pointSize = 10; };
      menu = { family = "IBM Plex Sans KR"; pointSize = 10; };
      toolbar = { family = "IBM Plex Sans KR"; pointSize = 10; };
      small = { family = "IBM Plex Sans KR"; pointSize = 8; };
      fixedWidth = { family = "Nordwand Mono"; pointSize = 10; };
    };

    kwin.virtualDesktops = {
      number = 4;
      rows = 2;
    };

    panels = [
      {
        location = "top";
        height = 44;
        floating = true;
        widgets = [
          { kickoff.icon = "view-calendar-agenda"; }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              extra = [
                "org.kde.plasma.notifications"
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.clipboard"
                "org.kde.kscreen"
              ];
              hidden = [
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
              ];
            };
          }
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    hotkeys.commands = {
      terminal = {
        name = "Terminal";
        key = "Meta+R";
        command = "alacritty";
      };
      htop = {
        name = "htop";
        key = "Ctrl+Shift+Esc";
        command = "alacritty -e htop";
      };
    };

    configFile = {
      kdeglobals.General = {
        TerminalApplication = "alacritty";
        TerminalService = "Alacritty.desktop";
      };
      kdeglobals.KDE.AnimationDurationFactor = 0;
      kwinrc.Plugins = {
        karouselEnabled = true;
        desktopchangeosdEnabled = true;
      };
      kwinrc.Wayland.InputMethod = "/usr/share/applications/kime.desktop";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "qdbus" ''exec /usr/lib64/qt6/bin/qdbus "$@"'')
  ];

  home.file.".local/share/kwin/scripts/karousel".source = "${karousel}/karousel";
}
