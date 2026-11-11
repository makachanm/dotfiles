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
      wallpaper = "${config.home.homeDirectory}/Pictures/wallpaper/untitled_01154_upscaled_4k.png";
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

    desktop.widgets = [
      {
        name = "org.kde.plasma.weather";
        position.horizontal = 64;
        position.vertical = 32;
        size.width = 576;
        size.height = 400;
        screen = 0;
        config.WeatherStation = {
          placeDisplayName = "Jeonju, South Korea, KR";
          placeInfo = "Jeonju, South Korea, KR|1845457";
          provider = "bbcukmet";
        };
      }
      {
        name = "org.kde.plasma.systemmonitor.memory";
        position.horizontal = 64;
        position.vertical = 432;
        size.width = 240;
        size.height = 240;
        screen = 0;
        config = {
          Configuration.CurrentPreset = "org.kde.plasma.systemmonitor";
          Appearance = {
            chartFace = "org.kde.ksysguard.piechart";
            title = "Memory Usage";
          };
          SensorColors."memory/physical/used" = "61,174,233";
          Sensors = {
            highPrioritySensorIds = ''["memory/physical/used"]'';
            lowPrioritySensorIds = ''["memory/physical/total"]'';
            totalSensors = ''["memory/physical/usedPercent"]'';
          };
        };
      }
      {
        name = "org.kde.plasma.systemmonitor.net";
        position.horizontal = 64;
        position.vertical = 672;
        size.width = 240;
        size.height = 240;
        screen = 0;
        config = {
          Configuration.CurrentPreset = "org.kde.plasma.systemmonitor";
          Appearance = {
            chartFace = "org.kde.ksysguard.linechart";
            title = "Network Speed";
          };
          SensorColors = {
            "network/all/download" = "61,174,233";
            "network/all/upload" = "233,120,61";
          };
          Sensors.highPrioritySensorIds = ''["network/all/download","network/all/upload"]'';
        };
      }
      {
        name = "org.kde.plasma.systemmonitor.cpucore";
        position.horizontal = 304;
        position.vertical = 432;
        size.width = 336;
        size.height = 480;
        screen = 0;
        config = {
          Configuration.CurrentPreset = "org.kde.plasma.systemmonitor";
          Appearance = {
            chartFace = "org.kde.ksysguard.barchart";
            title = "Individual Core Usage";
          };
          SensorColors = {
            "cpu/cpu.*/usage" = "61,174,233";
            "cpu/cpu0/usage" = "61,174,233";
            "cpu/cpu1/usage" = "61,110,233";
            "cpu/cpu10/usage" = "217,233,61";
            "cpu/cpu11/usage" = "153,233,61";
            "cpu/cpu12/usage" = "88,233,61";
            "cpu/cpu13/usage" = "61,233,98";
            "cpu/cpu14/usage" = "61,233,163";
            "cpu/cpu15/usage" = "61,233,227";
            "cpu/cpu2/usage" = "77,61,233";
            "cpu/cpu3/usage" = "141,61,233";
            "cpu/cpu4/usage" = "206,61,233";
            "cpu/cpu5/usage" = "233,61,196";
            "cpu/cpu6/usage" = "233,61,131";
            "cpu/cpu7/usage" = "233,61,67";
            "cpu/cpu8/usage" = "233,120,61";
            "cpu/cpu9/usage" = "233,184,61";
          };
          Sensors = {
            highPrioritySensorIds = ''["cpu/cpu.*/usage"]'';
            totalSensors = ''["cpu/all/usage"]'';
          };
        };
      }
      {
        name = "org.kde.plasma.webbrowser";
        position.horizontal = 64;
        position.vertical = 912;
        size.width = 576;
        size.height = 448;
        screen = 0;
        config.General = {
          enableNavigationBar = false;
          favIcon = "https://news.hada.io/favicon-dark.ico?20260826e";
          url = "https://news.hada.io/";
          useDefaultUrl = false;
          useFavIcon = false;
        };
      }
    ];

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
              "preferred://browser"
              "applications:thorium-browser.desktop"
              "applications:net.thunderbird.Thunderbird.desktop"
              "preferred://filemanager"
              "applications:org.kde.plasma-systemmonitor.desktop"
              "applications:org.speedcrunch.SpeedCrunch.desktop"
              "applications:com.microsoft.VSCode.desktop"
              "applications:slack.desktop"
              "applications:com.notion.app.desktop.notion.desktop"
              "applications:Goose.desktop"
              "applications:vesktop.desktop"
              "applications:com.ayugram.desktop.desktop"
              "applications:com.spotify.Client.desktop"
              "applications:gimp.desktop"
              "applications:org.kde.kdenlive.desktop"
              "applications:cockos-reaper.desktop"
              "applications:com.obsproject.Studio.desktop"
              "applications:steam.desktop"
              "applications:org.prismlauncher.PrismLauncher.desktop"
            ];
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.battery";
            config.General.showPercentage = true;
          }
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
          "org.kde.plasma.notifications"
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
        glideEnabled = true;
        scaleEnabled = false;
        zoomEnabled = false;
      };
      kwinrc.Xwayland.Scale = 1.45;
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
