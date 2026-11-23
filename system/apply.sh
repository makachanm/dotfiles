#!/bin/sh
set -e
out=$(nix build --no-link --print-out-paths "$(dirname "$(realpath "$0")")#systemConfigs.default")
pkexec /bin/sh -c "/usr/bin/nix-store -qR $out | xargs restorecon -R && $out/bin/register-profile && $out/bin/activate && restorecon -R /etc/keyd /etc/sddm.conf.d /etc/udev/rules.d /etc/systemd/system"
