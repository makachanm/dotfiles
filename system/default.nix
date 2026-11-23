{ pkgs, voidsddm }:
let
  user = "maka";

  coprs = [
    "toroidalfox/kime"
  ];

  packages = [
    "xdg-desktop-portal-kde"
    "sddm"
    "sddm-wayland-plasma"
    "keyd"
    "tuned-ppd"
    "thermald"
    "plasma-integration"
    "plasma-breeze"
    "kinfocenter"
    "gns3-server"
    "gns3-gui"
    "mupdf"
    "kime"
    "zsh"
    "git"
    "ripgrep"
    "fastfetch"
    "yt-dlp"
    "unrar"
    "unar"
    "xz-lzma-compat"
    "lhasa"
    "arj"
    "unace"
    "gcc"
    "gcc-c++"
    "make"
    "patch"
    "cmake"
    "meson"
    "ninja-build"
    "clang"
    "clang-tools-extra"
    "llvm"
    "flex"
    "bison"
    "bison-devel"
    "libfl-static"
    "glibc-static"
    "libstdc++-static"
    "openssl-devel"
    "libcurl-devel"
    "libXinerama-devel"
    "alsa-lib-devel"
    "libasan"
    "libubsan"
    "valgrind"
    "perf"
    "golang"
    "cargo"
    "nodejs22"
    "nodejs22-npm"
    "code"
    "texlive-scheme-basic"
    "texlive-collection-latexrecommended"
    "texlive-collection-xetex"
    "texlive-collection-langkorean"
    "latexmk"
    "vim-enhanced"
    "wl-clipboard"
    "moby-engine"
    "docker-compose"
    "toolbox"
    "libvirt-daemon-kvm"
    "libvirt-daemon-config-network"
    "thorium-browser"
    "ayugram-desktop"
    "steam-devices"
    "gstreamer1-plugins-bad-freeworld"
    "gstreamer1-plugins-ugly"
    "libavcodec-freeworld"
    "libheif-freeworld"
    "plasma-workspace"
    "plasma-desktop"
    "kwin"
    "dolphin"
    "plasma-systemsettings"
    "plasma-nm"
    "plasma-pa"
    "bluedevil"
    "powerdevil"
    "kscreen"
    "kde-gtk-config"
    "polkit-kde"
    "kdeplasma-addons"
    "nix"
    "nix-daemon"
    "spectacle"
    "konsole"
    "ark"
    "gwenview"
    "okular"
    "kate"
    "kde-partitionmanager"
    "plasma-discover"
    "plasma-discover-flatpak"
    "plasma-systemmonitor"
  ];

  flatpaks = [
    "app.zen_browser.zen"
    "us.zoom.Zoom"
    "com.slack.Slack"
    "dev.vencord.Vesktop"
    "com.spotify.Client"
    "com.notion.app.desktop.notion"
    "org.localsend.localsend_app"
    "org.kde.krita"
    "org.kde.kdenlive"
    "org.kde.digikam"
    "com.obsproject.Studio"
    "org.videolan.VLC"
    "org.libreoffice.LibreOffice"
    "org.speedcrunch.SpeedCrunch"
    "com.transmissionbt.Transmission"
    "org.kde.filelight"
    "org.kde.massif-visualizer"
    "org.kde.krdc"
    "org.kde.isoimagewriter"
    "com.valvesoftware.Steam"
    "org.prismlauncher.PrismLauncher"
    "net.pcsx2.PCSX2"
    "org.ghidra_sre.Ghidra"
  ];

  keyd = pkgs.writeText "keyd.conf" ''
    [ids]

    *

    [main]

    leftshift+leftmeta+f23 = sysrq
  '';

  sddm = pkgs.writeText "10-voidsddm.conf" ''
    [Theme]
    Current=voidsddm
  '';

  asUser = script: ''
    /usr/sbin/runuser -u ${user} -- /usr/bin/env -i HOME=/home/${user} USER=${user} PATH=/usr/bin:/bin /bin/sh -ec ${pkgs.lib.escapeShellArg script}
  '';

  repos = ''
    if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null; then
      dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi
    for copr in ${toString coprs}; do
      if ! dnf copr list | grep -q "/$copr$"; then
        dnf copr enable -y "$copr"
      fi
    done
    cp --no-preserve=mode ${./repos}/* /etc/yum.repos.d/
  '';

  dnfPackages = ''
    missing=""
    for p in ${toString packages}; do
      rpm -q --whatprovides "$p" >/dev/null 2>&1 || missing="$missing $p"
    done
    if [ -n "$missing" ]; then
      dnf install -y --skip-unavailable $missing
    fi
  '';

  tailscale = ''
    if ! rpm -q tailscale >/dev/null; then
      curl -fsSL https://tailscale.com/install.sh | sh
    fi
  '';

  udev = ''
    cp --no-preserve=mode ${./udev}/* /etc/udev/rules.d/
    udevadm control --reload
  '';

  keydConfig = ''
    mkdir -p /etc/keyd
    if ! cmp -s ${keyd} /etc/keyd/default.conf; then
      cp --no-preserve=mode ${keyd} /etc/keyd/default.conf
      systemctl restart keyd
    fi
    systemctl enable --now keyd
  '';

  sddmConfig = ''
    mkdir -p /etc/sddm.conf.d
    cp --no-preserve=mode ${sddm} /etc/sddm.conf.d/10-voidsddm.conf
    if ! diff -rq ${voidsddm} /usr/share/sddm/themes/voidsddm >/dev/null 2>&1; then
      rm -rf /usr/share/sddm/themes/voidsddm
      cp -r --no-preserve=mode ${voidsddm} /usr/share/sddm/themes/voidsddm
    fi
  '';

  grub = ''
    if ! cmp -s ${./grub} /etc/default/grub; then
      cp --no-preserve=mode ${./grub} /etc/default/grub
      grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
  '';

  herdr = asUser ''
    if [ ! -x "$HOME/.local/bin/herdr-app" ]; then
      curl -fsSL https://releases.herdr.dev/app/install.sh | sh
    fi
  '';

  claude = asUser ''
    if [ ! -x "$HOME/.local/bin/claude" ]; then
      curl -fsSL https://claude.ai/install.sh | bash
    fi
  '';

  opencode = asUser ''
    if [ ! -x "$HOME/.opencode/bin/opencode" ]; then
      curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
    fi
  '';

  typst = asUser ''
    if [ ! -x "$HOME/.cargo/bin/typst" ]; then
      cargo install -q --locked typst-cli
    fi
  '';

  zinit = asUser ''
    if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
      git clone -q https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
    fi
  '';

  flatpak = asUser ''
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --user --if-not-exists notion-origin https://app.linux-packages.notion.com/notion.flatpakrepo
    for app in ${toString flatpaks}; do
      if ! flatpak info --user "$app" >/dev/null 2>&1; then
        origin=flathub
        [ "$app" = com.notion.app.desktop.notion ] && origin=notion-origin
        flatpak install --user -y --noninteractive "$origin" "$app"
      fi
    done
    for app in $(flatpak list --user --app --columns=application); do
      case " ${toString flatpaks} " in
        *" $app "*) ;;
        *) flatpak uninstall --user -y --noninteractive "$app" ;;
      esac
    done
    flatpak uninstall --user -y --noninteractive --unused
  '';
in
pkgs.writeShellScript "system-apply" ''
  set -e
  export PATH=/usr/bin:/usr/sbin:/bin:/sbin
  ${repos}
  ${dnfPackages}
  ${tailscale}
  ${udev}
  ${keydConfig}
  ${sddmConfig}
  ${grub}
  ${herdr}
  ${claude}
  ${opencode}
  ${typst}
  ${zinit}
  ${flatpak}
''
