{ lib, pkgs, ... }:
let
  hiddenApps = [
    "im-chooser"
    "mupdf"
    "mupdf-gl"
    "org.kde.kmenuedit"
    "io.github.vectorgraphics.asymptote"
    "thorium-shell"
    "org.kde.plasma.emojier"
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

  home.packages = [
    pkgs.tinymist
  ];

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

  xdg.dataFile = {
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
    "applications/com.slack.Slack.desktop".text = ''
      [Desktop Entry]
      Name=Slack
      Exec=flatpak run --command=com.slack.Slack com.slack.Slack ${imeFlags} %U
      Icon=com.slack.Slack
      Type=Application
      StartupNotify=true
      StartupWMClass=Slack
      Categories=Network;InstantMessaging;
      MimeType=x-scheme-handler/slack;
    '';
    "applications/dev.vencord.Vesktop.desktop".text = ''
      [Desktop Entry]
      Name=Vesktop
      Exec=flatpak run --command=startvesktop dev.vencord.Vesktop ${imeFlags} %U
      Icon=dev.vencord.Vesktop
      Type=Application
      StartupWMClass=vesktop
      Categories=Network;
      MimeType=x-scheme-handler/discord;
    '';
    "kf.syntaxhighlighting/themes/Mono.theme".source = ./config/kate/Mono.theme;
    "fonts/NordwandMono".source = ./assets/fonts/NordwandMono;
  };

  home.file = {
    ".zshrc".source = ./config/zsh/zshrc;
    "Pictures/wallpaper/PIA26702~orig.png".source = ./assets/wallpaper + "/PIA26702~orig.png";
    "Pictures/wallpaper/untitled_01154_upscaled_4k.png".source = ./assets/wallpaper + "/untitled_01154_upscaled_4k.png";
  };

  home.activation.hideApps = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for app in ${lib.concatStringsSep " " hiddenApps}; do
      for dir in "$HOME/.local/share/flatpak/exports/share" /var/lib/flatpak/exports/share /usr/share; do
        src="$dir/applications/$app.desktop"
        if [ -f "$src" ]; then
          dest="$HOME/.local/share/applications/$app.desktop"
          run /usr/bin/install -Dm644 "$src" "$dest"
          run /usr/bin/sed -i -e '/^NoDisplay=/d' -e '0,/^\[Desktop Entry\]$/s//[Desktop Entry]\nNoDisplay=true/' "$dest"
          break
        fi
      done
    done
  '';

  home.activation.herdr = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/mkdir -p "$HOME/.config/herdr-app"
    run /usr/bin/cp -r --no-preserve=mode ${./config/herdr}/. "$HOME/.config/herdr-app/"
  '';

  home.activation.flatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/mkdir -p "$HOME/.local/share/flatpak/overrides"
    run /usr/bin/cp -r --no-preserve=mode ${./config/flatpak}/. "$HOME/.local/share/flatpak/overrides/"
  '';
}
