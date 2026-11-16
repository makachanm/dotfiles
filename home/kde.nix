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
          {
            name = "org.kde.plasma.kickerdash";
            config.General = {
              customButtonImage = "application-menu";
              useCustomButtonImage = true;
            };
            extraConfig = "(widget) => { widget.globalShortcut = 'Meta+Space'; }";
          }
          "org.kde.plasma.marginsseparator"
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
              "applications:org.kde.krita.desktop"
              "applications:org.kde.kdenlive.desktop"
              "applications:cockos-reaper.desktop"
              "applications:com.obsproject.Studio.desktop"
            ];
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.kvitals";
            config.General = {
              activeProfileId = "ed9157dc-f2b3-4bf8-998f-4fdc8bbfb653";
              backgroundType = "translucent";
              fontFamily = "IBM Plex Sans Medm";
              iconSize = 18;
              labelOpacity = 1;
              mergeFamilyMetrics = false;
              migrationDone = true;
              pinnedMetrics = "uptime/uptime,cpu/usage,ram/percentage";
              profileList = ''{"version":1,"profiles":[{"id":"ed9157dc-f2b3-4bf8-998f-4fdc8bbfb653","name":"Default","createdAt":1794804264811,"isDefault":true,"data":{"pinnedMetrics":"uptime/uptime,cpu/usage,ram/percentage","cpuEnabled":true,"cpuSubMetrics":"usage,freq,temp","cpuVisibility":"both","ramEnabled":true,"ramSubMetrics":"percentage","ramWidgetShowBoth":false,"ramVisibility":"both","ramUnit":"GiB","swapEnabled":false,"swapSubMetrics":"percent,used","swapVisibility":"both","tempEnabled":true,"tempLabel":"System","tempVisibility":"both","tempSensor":"auto","tempSelection":"","tempLabels":"","gpuEnabled":true,"gpuSubMetrics":"usage,vram,temp","gpuVisibility":"both","batEnabled":true,"batSubMetrics":"percentage,power","batVisibility":"both","netEnabled":true,"netSubMetrics":"down,up","netVisibility":"both","diskEnabled":false,"diskSubMetrics":"read,write","diskVisibility":"both","fanEnabled":false,"fanVisibility":"both","uptimeEnabled":false,"uptimeVisibility":"both","cpuLabel":"CPU","ramLabel":"RAM","swapLabel":"SWAP","diskLabel":"DSK","diskLabels":"","netLabel":"NET","networkInterface":"auto","showNetworkIp":false,"batteryDevice":"auto","batLabel":"BAT","gpuSelection":"","gpuLabels":"","fanLabel":"FAN","fanLabels":"","coolantLabels":"","displayMode":"icons","layoutType":"horizontal","iconSize":18,"mergeFamilyMetrics":false,"showSeparators":false,"backgroundType":"translucent","panelPadding":0,"cpuIcon":"cpu-symbolic","ramIcon":"memory-symbolic","swapIcon":"memory-symbolic","tempIcon":"temperature-symbolic","gpuIcon":"gpu-symbolic","batteryIcon":"battery-symbolic","powerIcon":"voltage-symbolic","networkIcon":"network-symbolic","diskIcon":"storage-symbolic","fanIcon":"fan-symbolic","uptimeIcon":"system-symbolic","fontFamily":"IBM Plex Sans Medm","fontSize":0,"fontBold":false,"metricOrder":"cpu,ram,swap,temp,gpu,bat,net,disk,fan,uptime","updateInterval":2000,"useCustomColors":false,"iconColor":"","labelColor":"","fontColor":"","enableThresholdColors":false,"warningColor":"#e5a50a","criticalColor":"#da4453","cpuWarningThreshold":70,"cpuCriticalThreshold":90,"tempWarningThreshold":60,"tempCriticalThreshold":85,"systemWarningThreshold":60,"systemCriticalThreshold":85,"ramWarningThreshold":70,"ramCriticalThreshold":90,"swapWarningThreshold":70,"swapCriticalThreshold":90,"ramTempWarningThreshold":60,"ramTempCriticalThreshold":85,"gpuWarningThreshold":70,"gpuCriticalThreshold":90,"gpuTempWarningThreshold":60,"gpuTempCriticalThreshold":85,"batteryWarningThreshold":30,"batteryCriticalThreshold":15,"diskWarningThreshold":80,"diskCriticalThreshold":90,"diskTempWarningThreshold":45,"diskTempCriticalThreshold":60,"coolantTempWarningThreshold":40,"coolantTempCriticalThreshold":50,"tempUnit":"C","networkUnit":"bytes","fanUnit":"rpm","fanMaxRpm":2000,"labelOpacity":1,"separatorOpacity":0.4}}]}'';
              shortcutInitialized = true;
              showSeparators = false;
            };
            extraConfig = "(widget) => { widget.globalShortcut = 'Meta+Shift+V'; }";
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.marginsseparator"
          {
            name = "io.github.fosvcat.betterkdebattery";
            config.General = {
              colorCharging = "#ffffff";
              colorLow = "#da4453";
              colorProfilePerformance = "#aa0000";
              colorProfilePowerSaver = "#00aa00";
              emptyOpacity = 30;
              numberFollowsRingColor = false;
              numberSize = 130;
              profileIndicatorSize = 130;
              ringScale = 130;
              ringThicknessScale = 70;
              sleepBlockedSymbol = 0;
            };
          }
          {
            name = "org.kde.plasma.digitalclock";
            config.Appearance = {
              dateFormat = "custom";
              customDateFormat = "yyyy MMM dd";
              displayTimezoneFormat = "UTCOffset";
              fontFamily = "IBM Plex Sans";
              fontSize = 7;
              fontStyleName = "Text";
              fontWeight = 450;
              showDate = false;
              use24hFormat = 0;
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
              alertsProvider = "librewxr";
              autoDetectLocation = true;
              compressedBadgePosition = "bottom-center";
              panelSimpleLayoutType = 2;
              panelSimpleTempShadowEnabled = false;
              radarEnabled = false;
              simpleFontAutoSz = 13;
              simpleIconAutoSz = 40;
              simpleIconSizeManual = 24;
              simplePanelDim = 32;
              simplePanelIsVertical = true;
              simplePanelLargeDim = 40;
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
        scaleEnabled = false;
        zoomEnabled = false;
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
      katerc."KTextEditor View" = {
        "Auto Color Theme Selection" = false;
        Theme = "Mono";
      };
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
    profiles.Mono = {
      colorScheme = "Mono";
      font = {
        name = "Nordwand Mono";
        size = 13;
      };
      extraConfig = {
        "Cursor Options".CursorShape = 0;
        General = {
          ShowTerminalSizeHint = false;
          TerminalCenter = true;
          TerminalMargin = 10;
        };
        Scrolling.ScrollBarPosition = 2;
        "Terminal Features".BlinkingCursorEnabled = true;
      };
    };
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
