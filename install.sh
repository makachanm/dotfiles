#!/usr/bin/env bash
#
# 새 시스템(Fedora 재설치 직후)에서 repo 클론 후 이 스크립트만 실행:
#   ./install.sh                전체 적용
#   ./install.sh --check --diff 바뀔 내용만 미리 보기
#   ./install.sh --tags home    일부만 적용
# Ansible이 없으면 설치한 뒤 site.yml을 실행한다. 인자는 ansible-playbook에 그대로 넘긴다.

set -euo pipefail
cd "$(dirname "$0")"

[[ $UID -ne 0 ]] || { echo "root로 실행하지 말고 일반 사용자로 실행하세요" >&2; exit 1; }

if ! rpm -q ansible-core ansible-collection-community-general >/dev/null 2>&1; then
  sudo dnf -y install ansible-core ansible-collection-community-general
fi

exec ansible-playbook site.yml "$@"
