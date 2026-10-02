#!/usr/bin/env bash
# Pinky rice — то, что применяется только внутри сеанса KDE Plasma:
# тема, иконки, курсор, обои, панели, виджеты, сочетания клавиш.
# Можно запускать повторно — это же «вернуть оформление, если слетело».
set -euo pipefail
R="$(cd "$(dirname "$0")/.." && pwd)"
[ "${XDG_CURRENT_DESKTOP:-}" = "KDE" ] || { echo "Эту часть нужно запускать внутри сеанса KDE Plasma."; exit 1; }

echo "==> Тема, иконки, курсор, обои"
plasma-apply-colorscheme StrawberryNight
/usr/lib/plasma-changeicons Papirus-Dark
plasma-apply-cursortheme --size 32 mizuki-psekai-cursor
plasma-apply-desktoptheme default
plasma-apply-wallpaperimage ~/.local/share/wallpapers/kanonbg-night.png

echo "==> 4 рабочих стола"
VDM=(org.kde.KWin /VirtualDesktopManager)
n=$(qdbus6 "${VDM[@]}" org.freedesktop.DBus.Properties.Get org.kde.KWin.VirtualDesktopManager count)
while [ "$n" -lt 4 ]; do
  qdbus6 "${VDM[@]}" org.kde.KWin.VirtualDesktopManager.createDesktop "$n" "Рабочий стол $((n+1))"
  n=$((n+1))
done

echo "==> Раскладка клавиатуры us,ru (Super+Space)"
dbus-send --session --type=signal /Layouts org.kde.keyboard.reloadConfig

echo "==> Панели внизу на всех мониторах и виджеты"
gdbus call --session --dest org.kde.plasmashell --object-path /PlasmaShell \
  --method org.kde.PlasmaShell.evaluateScript "$(cat "$R/kde/layout-classic.js")" >/dev/null
gdbus call --session --dest org.kde.plasmashell --object-path /PlasmaShell \
  --method org.kde.PlasmaShell.evaluateScript "$(cat "$R/kde/desktop-widgets.js")" >/dev/null

echo "==> Сочетания клавиш"
python3 "$R/kde/shortcuts.py" >/dev/null

qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
echo "Оформление KDE применено ♡"
