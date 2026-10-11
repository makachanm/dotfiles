#!/usr/bin/env bash
#
# dotfiles install script
# 새 시스템(Fedora 재설치 직후)에서 repo 클론 후 이 스크립트만 실행:
#   ./install.sh
# 옵션:
#   ./install.sh --dry-run   시스템 변경 없이 실행 내용만 출력
#   실행 중 sudo 비밀번호를 한 번 묻고 재사용함

set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
DRY=0
SUDO=""
SUDO_PID=""

bold=$'\e[1m'; dim=$'\e[2m'; red=$'\e[31m'; green=$'\e[32m'; yellow=$'\e[33m'; off=$'\e[0m'
info()  { echo "${bold}[ .  ]${off} $*"; }
ok()    { echo "${green}[ OK ]${off} $*"; }
warn()  { echo "${yellow}[ -- ]${off} $*"; }
die()   { echo "${red}[FAIL]${off} $*" >&2; exit 1; }

[[ "${1:-}" == "--dry-run" ]] && DRY=1
run() {
  if (( DRY )); then echo "${dim}  (dry) $*${off}"; else eval "$@"; fi
}

[[ $UID -ne 0 ]] || die "root로 실행하지 말고 일반 사용자로 실행하세요"

# ---------- 0. sudo 사전획득 ----------
if (( ! DRY )); then
  sudo -v
  # 스크립트 내내 sudo 캐시 유지 (백그라운드 갱신)
  ( while sudo -v; do sleep 30; done ) &
  SUDO_PID=$!
  trap 'kill $SUDO_PID 2>/dev/null; exit' EXIT INT TERM
fi

# ---------- 1. dnf 저장소 ----------
info "RPM Fusion 저장소 활성화"
run "sudo dnf -y install \
      https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm \
      https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-\$(rpm -E %fedora).noarch.rpm" || true

info "Fedora에서 제공하는 시스템 저장소 (dnf-repos.txt)"
while IFS= read -r repo; do
  [[ -z "$repo" || "$repo" == \#* ]] && continue
  case "$repo" in
    fedora|updates|fedora-cisco-openh264) run "sudo dnf config-manager setopt \"${repo}.enabled=1\"" ;;
    rpmfusion-free|rpmfusion-nonfree) : ;; # 위 rpmfusion 설치로 해결
    copr:*)                             : ;; # copr.txt에서 별도 처리
    tailscale-stable|WineHQ)            : ;; # yum.repos.d에서 복사
    *)                                  : ;;
  esac
done < "$REPO/system/packs/dnf-repos.txt"

info "서드파티 .repo 복사 (slack, tailscale, vscode, winehq)"
run "sudo cp -v $REPO/system/etc/yum.repos.d/*.repo /etc/yum.repos.d/"

info "COPR 저장소 활성화 (copr.txt)"
while IFS= read -r copr; do
  copr=$(echo "$copr" | xargs)
  [[ -z "$copr" || "$copr" == \#* ]] && continue
  run "sudo dnf -y copr enable \"$copr\"" || true
done < "$REPO/system/packs/copr.txt"

# ---------- 2. 패키지 설치 ----------
info "dnf 패키지 설치 (packs/dnf.txt)"
PKG_LIST=$(grep -v '^#' "$REPO/system/packs/dnf.txt" | sed '/^\s*$/d' | grep -v '^io\.' | grep -v '^org\.')
run "sudo dnf -y install $PKG_LIST"

info "flatpak 활성화 + 앱 설치 (packs/flatpak.txt)"
run "sudo dnf -y install flatpak"
run "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.repo" || true
while IFS= read -r app; do
  [[ -z "$app" || "$app" == \#* ]] && continue
  run "flatpak install -y --noninteractive flathub \"$app\"" || true
done < "$REPO/system/packs/flatpak.txt"

info "flatpak 테마 접근 설정 (GTK 설정/폰트/아이콘)"
run "flatpak override --user --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-4.0:ro --filesystem=xdg-config/fontconfig:ro --filesystem=/usr/share/icons:ro"

if [[ -s "$REPO/system/packs/cargo.txt" ]]; then
  info "cargo 툴 설치 (packs/cargo.txt)"
  run "cargo install \$(grep -v '^#' $REPO/system/packs/cargo.txt | sed '/^\s*\$/d')"
fi

# ---------- 3. 홈 설정 ----------
info "홈 설정 적용 (home/ -> \$HOME)"
while IFS= read -r -d '' src; do
  rel="${src#$REPO/home/}"
  dest="$HOME/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -rv "$src" "$dest"
done < <(find "$REPO/home" -type f -print0)

# ---------- 4. 시스템 설정 ----------
info "시스템 설정 적용 (system/etc -> /etc)"
while IFS= read -r -d '' src; do
  rel="${src#$REPO/system/etc/}"
  dest="/etc/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -rv "$src" "$dest"
done < <(find "$REPO/system/etc" -type f ! -path '*sddm/themes*' -print0)

# ---------- 5. 서비스 ----------
info "서비스 활성화"
run "sudo systemctl enable --now keyd.service"
run "sudo systemctl enable --now sddm"
run "sudo systemctl enable systemd-resolved 2>/dev/null || true"

# ---------- 6. dconf ----------
if [[ -d "$REPO/dconf" ]]; then
  info "dconf 설정 적용"
  for f in "$REPO"/dconf/*.ini; do
    [[ -f "$f" ]] || continue
    run "dconf load / < \"$f\""
  done
fi

# ---------- 7. 수동 항목 안내 ----------
ok "설치 완료"
echo
warn "수동 처리 필요 (packs/manual.txt):"
while IFS=$'\t' read -r name src dest cmd; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  echo "  - $name (${src})"
done < "$REPO/system/packs/manual.txt"
echo
warn "SDDM 테마(voidsddm) 설치:"
echo "  sudo ${REPO}/system/usr/share/sddm/themes/voidsddm/install.sh"
echo
warn "systemctl로 마무리:"
echo "  sudo systemctl enable --now batctl.service batctl-resume.service"
echo "  sudo batctl set --start 30 --stop 85 && sudo batctl persist enable"
echo "  sudo systemctl restart keyd sddm"
