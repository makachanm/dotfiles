{ config, lib, pkgs, ... }:
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
      wallpaper = "${config.home.homeDirectory}/Pictures/wallpaper/PIA26702~orig.png";
    };

    fonts = {
      general = { family = "IBM Plex Sans KR"; pointSize = 10; };
      menu = { family = "IBM Plex Sans KR"; pointSize = 10; };
      toolbar = { family = "IBM Plex Sans KR"; pointSize = 10; };
      small = { family = "IBM Plex Sans KR"; pointSize = 8; };
      fixedWidth = { family = "Nordwand Mono"; pointSize = 10; };
    };

    powerdevil = {
      AC.inhibitLidActionWhenExternalMonitorConnected = true;
      battery.inhibitLidActionWhenExternalMonitorConnected = true;
      lowBattery.inhibitLidActionWhenExternalMonitorConnected = true;
    };

    input.touchpads = [
      {
        name = "ELAN06C7:00 04F3:3193 Touchpad";
        vendorId = "04f3";
        productId = "3193";
        naturalScroll = true;
      }
    ];

    kwin.virtualDesktops = {
      number = 4;
      rows = 2;
    };

    panels = [
      {
        location = "top";
        height = 36;
        floating = false;
        opacity = "opaque";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config.General = {
              icon = "/usr/share/pixmaps/fedora-logo-sprite.png";
              compactMode = true;
              favoritesDisplay = 1;
              primaryActions = 3;
              showActionButtonCaptions = false;
              systemFavorites = "lock-screen\\,logout\\,save-session\\,switch-user\\,suspend\\,hibernate\\,reboot\\,shutdown";
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.icontasks";
            config.General = {
              launchers = "";
              reverseMode = true;
              showOnlyCurrentScreen = true;
              sortingStrategy = 2;
            };
          }
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.notes";
            config.General.noteId = "notes";
          }
          {
            name = "org.kde.plasma.systemtray";
            config.General = {
              extraItems = [
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.notifications"
              ];
              hiddenItems = [
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.notifications"
              ];
              reverseIconOrder = true;
              scaleIconsToFit = false;
              disabledStatusNotifiers = "Xwayland Video Bridge";
            };
          }
          {
            name = "org.kde.plasma.battery";
            config.General.showPercentage = true;
          }
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    shortcuts = {
      kwin = {
        "karousel-focus-left" = "Meta+Q";
        "karousel-focus-right" = "Meta+W";
        "karousel-focus-up" = [ ];
        "karousel-focus-down" = [ ];
        "karousel-column-move-left" = "Meta+A";
        "karousel-column-move-right" = "Meta+S";
        "karousel-column-width-increase" = "Meta+E";
        "karousel-column-width-decrease" = "Meta+D";
        "karousel-column-width-maximize" = "Meta+Z";
        "Window Fullscreen" = [ ];
        "Window Close" = [ "Meta+C" "Alt+F4" ];
        "karousel-window-toggle-floating" = "Meta+X";
        "karousel-column-toggle-stacked" = [ ];
        "karousel-cycle-preset-widths" = [ ];
        "karousel-column-move-to-next-desktop" = [ ];
        "Switch to Next Desktop" = "Meta+Tab";
        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
        "Window to Next Screen" = "Meta+Shift+Tab";
        "Overview" = [ ];
        "Show Desktop" = [ ];
        "disableInputCapture" = [ ];
      };
      plasmashell = {
        "manage activities" = [ ];
        "next activity" = [ ];
        "previous activity" = [ ];
        "show-on-mouse-pos" = "Meta+V";
      };
      ksmserver = {
        "Lock Session" = [ "Meta+L" "Screensaver" ];
        "Log Out" = [ "Meta+Shift+Esc" "Ctrl+Alt+Del" ];
      };
      "services/org.kde.krunner.desktop"._launch = "Alt+Space";
      "services/org.kde.dolphin.desktop"._launch = [ ];
      "services/org.kde.spectacle.desktop" = {
        RectangularRegionScreenShot = "Meta+F";
        FullScreenScreenShot = "Meta+Shift+F";
      };
    };

    hotkeys.commands = {
      settings = {
        name = "System Settings";
        key = "Meta+,";
        command = "systemsettings";
      };
      terminal = {
        name = "Terminal";
        key = "Meta+R";
        command = "konsole";
      };
      systemMonitor = {
        name = "System Monitor";
        key = "Ctrl+Shift+Esc";
        command = "plasma-systemmonitor";
      };
    };

    configFile = {
      kdeglobals.General = {
        TerminalApplication = "konsole";
        TerminalService = "org.kde.konsole.desktop";
      };
      kwinrc.Plugins = {
        karouselEnabled = true;
        desktopchangeosdEnabled = true;
        diminactiveEnabled = true;
      };
      kwinrc.Script-karousel = {
        untileOnDrag = false;
        gapsOuterTop = 10;
        gapsOuterBottom = 10;
        gapsOuterLeft = 10;
        gapsOuterRight = 10;
        gapsInnerHorizontal = 10;
        gapsInnerVertical = 10;
        gestureScroll = true;
        presetWidths = "10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%";
      };
      kwinrc.Wayland.InputMethod = "/usr/share/applications/kime.desktop";
      kwinrc.Windows = {
        RollOverDesktops = true;
        FocusStealingPreventionLevel = 2;
        ElectricBorderMaximize = false;
        ElectricBorderTiling = false;
      };
      kwinrc.Effect-overview.BorderActivate = 9;
      ksplashrc.KSplash = {
        Engine = "none";
        Theme = "None";
      };
      dolphinrc.MainWindow.MenuBar = "Disabled";
      konsolerc."Desktop Entry".DefaultProfile = "Mono.profile";
      konsolerc.KonsoleWindow.ShowMenuBarByDefault = false;
      konsolerc.TabBar = {
        TabBarVisibility = "AlwaysHideTabBar";
        NewTabButton = false;
        CloseTabButton = "None";
      };
    };
  };

  home.activation.konsoleToolbars = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for bar in mainToolBar sessionToolbar; do
      run /usr/bin/kwriteconfig6 --file konsolerc --group MainWindow --group "Toolbar $bar" --key Hidden true
    done
  '';

  home.packages = [
    (pkgs.writeShellScriptBin "qdbus" ''exec /usr/lib64/qt6/bin/qdbus "$@"'')
  ];

  home.file.".local/share/kwin/scripts/karousel".source = "${karousel}/karousel";

  # /usr/bin/zen-browser creates ~/.zen/native-messaging-hosts under KDE, and
  # once ~/.zen exists Zen treats it as the legacy home and starts a fresh
  # profile there. Point ~/.zen at the real XDG profile dir instead.
  home.file.".zen".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/zen";
}
