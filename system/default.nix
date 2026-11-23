{ pkgs, ... }:
let
  etcFile = attrs: {
    mode = "0644";
    replaceExisting = true;
  } // attrs;
in
{
  nixpkgs.hostPlatform = "x86_64-linux";
  system-manager.allowAnyDistro = true;
  services.userborn.enable = false;

  systemd.tmpfiles.rules = [ "L+ /usr/local/bin/tailscale - - - - ${pkgs.tailscale}/bin/tailscale" ];

  environment.etc = {
    "profile.d/system-manager-path.sh".enable = false;
    "environment.d/10-system-manager.conf".enable = false;
    "keyd/default.conf" = etcFile {
      text = ''
        [ids]

        *

        [main]

        leftshift+leftmeta+f23 = sysrq
      '';
    };
    "sddm.conf.d/10-voidsddm.conf" = etcFile {
      text = ''
        [Theme]
        Current=voidsddm
      '';
    };
  };

  systemd.services.udev-rules = {
    wantedBy = [ "system-manager.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      /usr/bin/cp --no-preserve=mode ${./udev}/* /etc/udev/rules.d/
      /usr/bin/udevadm control --reload
    '';
  };

  systemd.services.tailscaled = {
    description = "Tailscale node agent";
    wants = [ "network-pre.target" ];
    after = [ "network-pre.target" "NetworkManager.service" "systemd-resolved.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tailscale}/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=41641";
      ExecStopPost = "${pkgs.tailscale}/bin/tailscaled --cleanup";
      Restart = "on-failure";
      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = "0755";
      StateDirectory = "tailscale";
      StateDirectoryMode = "0700";
      CacheDirectory = "tailscale";
      CacheDirectoryMode = "0750";
      Type = "notify";
    };
  };
}
