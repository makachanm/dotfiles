{ lib, ... }:
let
  copied = {
    ".config/htop/htoprc" = ./config/htop/htoprc;
    ".local/share/konsole/Mono.profile" = ./config/konsole/Mono.profile;
    ".config/SpeedCrunch/SpeedCrunch.ini" = ./config/speedcrunch/SpeedCrunch.ini;
    ".config/vlc/vlcrc" = ./config/vlc/vlcrc;
    ".config/mimeapps.list" = ./config/desktop/mimeapps.list;
    ".config/user-dirs.dirs" = ./config/desktop/user-dirs.dirs;
    ".claude/settings.json" = ./config/claude/settings.json;
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

  home.file = {
    ".zshrc".source = ./config/zsh/zshrc;
    ".config/vim/vimrc".source = ./config/vim/vimrc;
    ".local/share/konsole/Mono.colorscheme".source = ./config/konsole/Mono.colorscheme;
    ".local/share/SpeedCrunch/color-schemes/Mono.json".source = ./config/speedcrunch/Mono.json;
    ".config/kime/config.yaml".source = ./config/kime/config.yaml;
    ".config/fontconfig/fonts.conf".source = ./config/fontconfig/fonts.conf;
    ".config/environment.d/50-session.conf".source = ./config/desktop/environment.conf;
    ".local/share/applications/vim.desktop".source = ./config/applications/vim.desktop;
    ".local/share/applications/im-chooser.desktop".source = ./config/applications/im-chooser.desktop;
    ".local/share/applications/io.github.vectorgraphics.asymptote.desktop".source = ./config/applications/io.github.vectorgraphics.asymptote.desktop;
    ".local/share/applications/mupdf-gl.desktop".source = ./config/applications/mupdf-gl.desktop;
    ".local/share/applications/thorium-shell.desktop".source = ./config/applications/thorium-shell.desktop;
    ".local/share/fonts/NordwandMono".source = ./assets/fonts/NordwandMono;
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
    clock-format = "24h";
    clock-show-weekday = true;
    cursor-blink = true;
    cursor-blink-time = 1200;
    cursor-blink-timeout = 10;
    cursor-size = 24;
    document-font-name = "IBM Plex Sans KR Medium 12";
    enable-animations = true;
    enable-hot-corners = false;
    font-name = "IBM Plex Sans KR 10";
    gtk-enable-primary-paste = true;
    gtk-im-module = "";
    gtk-key-theme = "";
    monospace-font-name = "Nordwand Mono 11";
    overlay-scrolling = true;
    show-battery-percentage = true;
    toolkit-accessibility = false;
  };
}
