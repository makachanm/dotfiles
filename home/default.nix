{ lib, pkgs, ... }:
let
  copied = {
    ".local/share/konsole/Mono.profile" = ./config/konsole/Mono.profile;
    ".config/SpeedCrunch/SpeedCrunch.ini" = ./config/speedcrunch/SpeedCrunch.ini;
  };
  hiddenApps = [
    "im-chooser"
    "io.github.vectorgraphics.asymptote"
    "thorium-shell"
  ];
  kimeOsd = pkgs.writeShellScript "kime-osd" (builtins.readFile ./config/kime/kime-osd);
  imeFlags = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
  thoriumFlags = imeFlags + " --password-store=basic";
  autostart = name: exec: {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=${name}
      Exec=${exec}
      NoDisplay=true
      X-KDE-autostart-phase=2
    '';
  };
in
{
  imports = [
    ./kde.nix
  ];

  home.username = "maka";
  home.homeDirectory = "/home/maka";
  home.stateVersion = "26.11";

  programs.home-manager.enable = true;
  programs.man.enable = false;
  xdg.mime.enable = false;

  xdg.userDirs = {
    enable = true;
    package = null;
    projects = null;
  };

  systemd.user.sessionVariables = {
    GTK_IM_MODULE = "kime";
    QT_IM_MODULE = "kime";
    QT_IM_MODULES = "wayland;kime";
    XMODIFIERS = "@im=kime";
    SDL_IM_MODULE = "kime";
    GLFW_IM_MODULE = "kime";
    INPUT_METHOD = "kime";
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";
    defaultFonts.monospace = [
      "Nordwand Mono"
      "Noto Sans Mono CJK KR"
      "Noto Sans Mono"
    ];
  };

  xdg.configFile = {
    "autostart/tailscale-systray.desktop" = autostart "Tailscale" "tailscale systray";
    "autostart/kime-osd.desktop" = autostart "kime OSD" "${kimeOsd}";
    "kime/config.yaml".source = ./config/kime/config.yaml;
    "vim/vimrc".source = ./config/vim/vimrc;
    "thorium/thorium-flags.conf".text = thoriumFlags;
  };

  xdg.dataFile = lib.genAttrs (map (app: "applications/${app}.desktop") hiddenApps) (_: {
    text = ''
      [Desktop Entry]
      Hidden=true
    '';
  }) // {
    "applications/com.microsoft.VSCode.desktop".text = ''
      [Desktop Entry]
      Name=Visual Studio Code
      GenericName=Text Editor
      Exec=/usr/share/code/code ${imeFlags} %F
      Icon=vscode
      Type=Application
      StartupNotify=false
      StartupWMClass=com.microsoft.VSCode
      Categories=TextEditor;Development;IDE;
      MimeType=application/x-code-workspace;
      Actions=new-empty-window;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=/usr/share/code/code ${imeFlags} --new-window %F
      Icon=vscode
    '';
    "applications/slack.desktop".text = ''
      [Desktop Entry]
      Name=Slack
      Exec=/usr/bin/slack ${imeFlags} %U
      Icon=/usr/share/pixmaps/slack.png
      Type=Application
      StartupNotify=true
      StartupWMClass=Slack
      Categories=Network;InstantMessaging;
      MimeType=x-scheme-handler/slack;
    '';
    "applications/vesktop.desktop".text = ''
      [Desktop Entry]
      Name=Vesktop
      Exec=/opt/Vesktop/vesktop ${imeFlags} %U
      Icon=vesktop
      Type=Application
      StartupWMClass=vesktop
      Categories=Network;
      MimeType=x-scheme-handler/discord;
    '';
    "fonts/NordwandMono".source = ./assets/fonts/NordwandMono;
  };

  home.file = {
    ".zshrc".source = ./config/zsh/zshrc;
    "Pictures/wallpaper/PIA26702~orig.png".source = ./assets/wallpaper + "/PIA26702~orig.png";
    "Pictures/wallpaper/untitled_01154_upscaled_4k.png".source = ./assets/wallpaper + "/untitled_01154_upscaled_4k.png";
  };

  home.activation.copyConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (
      lib.mapAttrsToList (dest: src: ''
        run install -Dm644 ${src} "$HOME/${dest}"
      '') copied
    )
  );

  home.activation.zinit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
      run /usr/bin/git clone -q https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
    fi
  '';
}
