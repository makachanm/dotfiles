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
      iconTheme = "breeze-dark";
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
            name = "org.kde.plasma.kickerdash";
            config.General = {
              customButtonImage = "preferences-other-symbolic";
              useCustomButtonImage = true;
              highlightNewlyInstalledApps = false;
              recentOrdering = 1;
              showRecentApps = false;
              showRecentDocs = false;
            };
            extraConfig = "(widget) => { widget.globalShortcut = 'Meta+Space'; }";
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.icontasks";
            config.General.launchers = [
              "preferred://filemanager"
              "applications:org.speedcrunch.SpeedCrunch.desktop"
              "applications:org.kde.kate.desktop"
              "applications:com.microsoft.VSCode.desktop"
              "applications:com.ayugram.desktop.desktop"
              "applications:thorium-browser.desktop"
              "preferred://browser"
              "applications:slack.desktop"
              "applications:vesktop.desktop"
              "applications:com.spotify.Client.desktop"
              "applications:org.kde.konsole.desktop"
            ];
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.battery";
            config.General.showPercentage = true;
          }
          "org.kde.plasma.notifications"
          {
            name = "org.kde.plasma.digitalclock";
            config.Appearance = {
              autoFontAndSize = false;
              dateFormat = "custom";
              customDateFormat = "yyyy MMM dd";
              displayTimezoneFormat = "UTCOffset";
              fontFamily = "IBM Plex Sans";
              fontSize = 11;
              fontStyleName = "Text";
              fontWeight = 450;
            };
          }
          "org.kde.plasma.marginsseparator"
        ];
      }
      {
        location = "right";
        alignment = "right";
        lengthMode = "fit";
        hiding = "autohide";
        floating = true;
        height = 40;
        widgets = [
          {
            name = "org.kde.plasma.systemtray";
            config.General = {
              extraItems = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.kscreen"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.mediacontroller"
              ];
              hiddenItems = [
                "org.kde.plasma.clipboard"
                "org.kde.plasma.mediacontroller"
              ];
              shownItems = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
              ];
              disabledStatusNotifiers = "Xwayland Video Bridge";
            };
          }
          {
            name = "org.kde.plasma.notes";
            config.General = {
              noteId = "notes";
              color = "black";
              fontSize = 10;
            };
          }
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
        "Window Close" = [ "Meta+Backspace" "Alt+F4" ];
        "Window Restore" = [ ];
        "karousel-window-toggle-floating" = "Meta+Shift+Z";
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
        "activate application launcher" = [ ];
      };
      ksmserver = {
        "Lock Session" = [ "Meta+L" "Screensaver" ];
        "Log Out" = [ "Meta+Shift+Esc" "Ctrl+Alt+Del" ];
      };
      "services/org.kde.krunner.desktop"._launch = "Alt+Space";
      "services/org.kde.dolphin.desktop"._launch = [ ];
      "services/org.kde.spectacle.desktop" = {
        RectangularRegionScreenShot = "Meta+X";
        FullScreenScreenShot = "Meta+Shift+X";
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
        key = "Meta+C";
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
      kwinrc.ModifierOnlyShortcuts.Meta = "";
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
      gwenviewrc.MainWindow.MenuBar = "Disabled";
      okularpartrc."Main View" = {
        ShowLeftPanel = false;
        ShowBottomBar = false;
      };
      "kdeconnect/config".General.disabled_providers_v2 = "loopback, lan";
    };
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "Mono";
    customColorSchemes.Mono = ./config/konsole/Mono.colorscheme;
    extraConfig = {
      KonsoleWindow.ShowMenuBarByDefault = false;
      TabBar = {
        TabBarVisibility = "AlwaysHideTabBar";
        NewTabButton = false;
        CloseTabButton = "None";
      };
      "MainWindow/Toolbar mainToolBar".Hidden = true;
      "MainWindow/Toolbar sessionToolbar".Hidden = true;
    };
  };

  programs.okular = {
    enable = true;
    package = null;
    general = {
      showMenuBar = false;
      showSidebar = false;
    };
  };

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
