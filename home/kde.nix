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
      AC = {
        inhibitLidActionWhenExternalMonitorConnected = true;
        powerButtonAction = "hibernate";
        autoSuspend.idleTimeout = 1800;
      };
      battery = {
        inhibitLidActionWhenExternalMonitorConnected = true;
        powerButtonAction = "hibernate";
      };
      lowBattery = {
        inhibitLidActionWhenExternalMonitorConnected = true;
        powerButtonAction = "hibernate";
        autoSuspend.action = "hibernate";
      };
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

    desktop.widgets = [ ];

    panels = [
      {
        location = "top";
        height = 38;
        floating = false;
        opacity = "opaque";
        widgets = [
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.kickerdash";
            config.General = {
              customButtonImage = "application-menu";
              useCustomButtonImage = true;
            };
            extraConfig = "(widget) => { widget.globalShortcut = 'Meta+Space'; }";
          }
          {
            name = "org.kde.plasma.panelspacer";
            config.General = {
              expanding = false;
              length = 5;
            };
          }
          "org.kde.plasma.pager"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.icontasks";
            config.General.launchers = [
              "preferred://browser"
              "applications:thorium-browser.desktop"
              "applications:net.thunderbird.Thunderbird.desktop"
              "preferred://filemanager"
              "applications:org.speedcrunch.SpeedCrunch.desktop"
              "applications:com.microsoft.VSCode.desktop"
              "applications:slack.desktop"
              "applications:com.notion.app.desktop.notion.desktop"
              "applications:Goose.desktop"
              "applications:vesktop.desktop"
              "applications:com.ayugram.desktop.desktop"
              "applications:com.spotify.Client.desktop"
              "applications:steam.desktop"
              "applications:org.prismlauncher.PrismLauncher.desktop"
              "applications:gimp.desktop"
              "applications:org.kde.kdenlive.desktop"
              "applications:cockos-reaper.desktop"
              "applications:com.obsproject.Studio.desktop"
            ];
          }
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.resources-monitor";
            config.Appearance = {
              abbreviate = true;
              autoFontAndSize = false;
              displayment = "always";
              fontFamily = "IBM Plex Sans Text";
              fontSize = 7;
              fontStyleName = "Regular";
              fontWeight = 450;
              keepFontSize = true;
            };
            config.General.graphs = ''[{"_v":4,"type":"cpu","sizes":[46,-1],"fontSize":-1,"colors":["highlightColor","textColor","textColor"],"sensorsType":["usage","none",false],"thresholds":[85,105],"clockAggregator":"average","eCoresCount":0},{"_v":4,"type":"memory","sizes":[46,-1],"fontSize":-1,"colors":["highlightColor","negativeTextColor"],"sensorsType":["physical-percent","none"],"thresholds":[70,90]},{"_v":4,"type":"networkText","sizes":[-1,-1],"fontSize":-1,"colors":["highlightColor","positiveTextColor"],"sensorsType":[false,"kibibyte"],"ignoredInterfaces":[],"icons":true}]'';
          }
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
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.systemtray";
            config.General = {
              extraItems = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
              ];
              shownItems = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
              ];
              disabledStatusNotifiers = "Xwayland Video Bridge,kime";
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.advanced-weather-widget";
            config.General = {
              activeLocation = ''{"name":"전주시, 전북특별자치도, 대한민국","lat":35.8434,"lon":127.14,"altitude":51,"timezone":"Asia/Seoul","countryCode":"KR"}'';
              alertsProvider = "librewxr";
              altitude = 51;
              autoDetectLocation = true;
              compressedBadgePosition = "bottom-center";
              countryCode = "KR";
              latitude = 35.8434;
              locationName = "전주시, 전북특별자치도, 대한민국";
              longitude = 127.14;
              panelSimpleLayoutType = 2;
              panelSimpleTempShadowEnabled = false;
              radarEnabled = false;
              savedLocations = ''[{"name":"전주시, 전북특별자치도, 대한민국","lat":35.8434,"lon":127.14,"altitude":51,"timezone":"Asia/Seoul","countryCode":"KR","starred":true}]'';
              simpleFontAutoSz = 13;
              simpleIconAutoSz = 40;
              simpleIconSizeManual = 24;
              simplePanelDim = 32;
              simplePanelIsVertical = true;
              simplePanelLargeDim = 40;
              timezone = "Asia/Seoul";
              tooltipEnabled = false;
              weatherProvider = "bbc";
              widgetLayoutMode = "simple";
              widgetSimpleDetailsItemIcons = "feelslike=1;humidity=1;pressure=1;dewpoint=1;visibility=1;preciprate=1;precipsum=1;uvindex=1;airquality=1;pollen=1;spaceweather=1;alerts=1;snowcover=1;datetime=1";
              widgetSimpleDetailsOrder = "humidity;feelslike;airquality";
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
      kuriikwsfilterrc.General = {
        EnableWebShortcuts = true;
        KeywordDelimiter = ":";
        UsePreferredWebShortcutsOnly = false;
      };
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
