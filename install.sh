#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

[[ $UID -ne 0 ]] || { echo "root로 실행하지 말고 일반 사용자로 실행하세요" >&2; exit 1; }

if ! rpm -q ansible-core ansible-collection-community-general >/dev/null 2>&1; then
  sudo dnf -y install ansible-core ansible-collection-community-general
fi

exec ansible-playbook site.yml "$@"
