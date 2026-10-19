# dotfiles

Fedora 44 + niri + Noctalia 데스크톱 설정.

## 구조

| 경로 | 내용 |
|---|---|
| `home/` | `$HOME`에 그대로 복사되는 사용자 설정 |
| `system/etc/` | `/etc`에 복사되는 시스템 설정 (greetd, keyd, grub, udev, 저장소) |
| `system/var/lib/noctalia-greeter/` | 로그인 화면(Noctalia Greeter) 설정 |
| `system/packs/` | 패키지 목록: `dnf.txt`, `dnf-repos.txt`, `copr.txt`, `flatpak.txt`, `cargo.txt` |
| `dconf/` | dconf 경로별 설정 (`org.gnome.desktop.interface.ini` → `/org/gnome/desktop/interface/`) |
| `install.sh` | 새 시스템에 위 내용을 적용하는 스크립트 (`--dry-run` 지원) |

## 구성

- 컴포지터: niri
- 셸: Noctalia (바, 런처, 알림, 잠금 화면, 자동 잠금, 클립보드, 권한 확인)
- 로그인: greetd + Noctalia Greeter
- 입력기: kime
- 테마: Mono 흑백 팔레트 (`home/.config/noctalia/palettes/Mono.json`) → GTK, KDE 색, niri 테두리
- 배터리 충전 제한: UPower (`system/etc/udev/hwdb.d/61-battery-local.hwdb`)
