{ lib, pkgs, ... }:
let
  copied = {
    ".local/share/konsole/Mono.profile" = ./config/konsole/Mono.profile;
    ".config/SpeedCrunch/SpeedCrunch.ini" = ./config/speedcrunch/SpeedCrunch.ini;
    ".config/mimeapps.list" = ./config/desktop/mimeapps.list;
    ".claude/settings.json" = ./config/claude/settings.json;
  };
  hiddenApps = [
    "im-chooser"
    "io.github.vectorgraphics.asymptote"
    "mupdf-gl"
    "thorium-shell"
  ];
  kimeOsd = pkgs.writeShellScript "kime-osd" (builtins.readFile ./config/kime/kime-osd);
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
  };

  xdg.dataFile = lib.genAttrs (map (app: "applications/${app}.desktop") hiddenApps) (_: {
    text = ''
      [Desktop Entry]
      Hidden=true
    '';
  }) // {
    "applications/vim.desktop".source = ./config/applications/vim.desktop;
    "SpeedCrunch/color-schemes/Mono.json".source = ./config/speedcrunch/Mono.json;
    "kxmlgui5/okular/part.rc".source = ./config/okular/part.rc;
    "fonts/NordwandMono".source = ./assets/fonts/NordwandMono;
  };

  home.file = {
    ".zshrc".source = ./config/zsh/zshrc;
    "Pictures/wallpaper/PIA26702~orig.png".source = ./assets/wallpaper + "/PIA26702~orig.png";
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

  dconf.settings."org/gnome/desktop/interface" = {
    cursor-blink = true;
    cursor-blink-time = 1200;
    cursor-blink-timeout = 10;
    cursor-size = 24;
    document-font-name = "IBM Plex Sans KR Medium 12";
    font-name = "IBM Plex Sans KR 10";
    monospace-font-name = "Nordwand Mono 11";
    toolkit-accessibility = false;
  };
}
