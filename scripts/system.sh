#!/usr/bin/env bash
# Pinky rice — системная часть: пакеты, шрифт и курсор для экрана входа, SDDM с темой.
# Нужен sudo. Обычно вызывается из ../install.sh
set -euo pipefail
R="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Пакеты: KDE Plasma и программы"
sudo pacman -S --needed plasma-meta \
    dolphin kate gwenview okular ark kcalc partitionmanager filelight haruna skanpage konsole \
    ffmpegthumbs kdegraphics-thumbnailers kio-extras \
    kitty neovim fastfetch python curl libarchive

echo "==> Пакеты: niri и всё для него"
# xdg-desktop-portal-gnome — демонстрация экрана в niri (заодно ставит Nautilus, он нужен для Super+E)
sudo pacman -S --needed niri xwayland-satellite waybar rofi dunst swaylock-effects swayidle awww \
    playerctl brightnessctl grim slurp swappy cliphist wl-clipboard xdg-desktop-portal-gnome \
    pavucontrol libnotify ttf-nerd-fonts-symbols

echo "==> Экран входа: SDDM + тема astronaut «pinky»"
sudo pacman -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
sudo install -Dm644 -t /usr/share/fonts/TTF "$R"/fonts/*.ttf
sudo rm -rf /usr/share/icons/mizuki-psekai-cursor /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r "$R/icons/mizuki-psekai-cursor" /usr/share/icons/
sudo cp -r "$R/sddm/sddm-astronaut-theme" /usr/share/sddm/themes/
sudo fc-cache -f >/dev/null
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/10-pinky.conf >/dev/null <<'EOF'
[General]
# экран входа работает на Wayland через KWin (X-сервер не нужен)
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
InputMethod=

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1

[Theme]
Current=sddm-astronaut-theme
CursorTheme=mizuki-psekai-cursor
CursorSize=32
EOF

for dm in plasmalogin gdm lightdm ly; do
  systemctl is-enabled "$dm.service" &>/dev/null && sudo systemctl disable "$dm.service" || true
done
sudo systemctl enable sddm.service

echo "Системная часть готова."
