{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "Mono";
      iconTheme = "Papirus-Dark";
      widgetStyle = "Breeze";
      wallpaper = ./assets/wallpaper + "/PIA26702~orig.png";
    };

    fonts = {
      general = { family = "IBM Plex Sans KR"; pointSize = 10; };
      menu = { family = "IBM Plex Sans KR"; pointSize = 10; };
      toolbar = { family = "IBM Plex Sans KR"; pointSize = 10; };
      small = { family = "IBM Plex Sans KR"; pointSize = 8; };
      fixedWidth = { family = "Nordwand Mono"; pointSize = 10; };
    };

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
      kwinrc.Plugins.karouselEnabled = true;
      kwinrc.Wayland.InputMethod = "/usr/share/applications/kime.desktop";
    };
  };

  home.file = {
    ".local/share/kwin/scripts/karousel".source = "${pkgs.kdePackages.karousel}/share/kwin/scripts/karousel";
    ".local/share/color-schemes/Mono.colors".source = ./config/kde/Mono.colors;
  };
}
