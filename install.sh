#!/usr/bin/env bash
# Pinky rice (KDE Plasma + niri) — установка одной командой.
#   ./install.sh           — всё: пакеты (sudo), настройки, и если ты уже в KDE — сразу оформление
#   ./install.sh --plasma  — только применить оформление KDE (запускать внутри сеанса Plasma)
#   ./install.sh --user    — только файлы и настройки, без пакетов
set -euo pipefail
cd "$(dirname "$0")"
chmod +x scripts/*.sh niri/bin/*

case "${1:-}" in
  --plasma) exec bash scripts/plasma.sh ;;
  --user)   bash scripts/user.sh ;;
  *)        bash scripts/system.sh; bash scripts/user.sh ;;
esac

if [ "${XDG_CURRENT_DESKTOP:-}" = "KDE" ]; then
  bash scripts/plasma.sh
  echo
  echo "Готово ♡ Перезагрузись: на экране входа можно выбрать «Plasma (Wayland)» или «Niri»."
else
  echo
  echo "Готово ♡ Перезагрузись, войди в «Plasma (Wayland)» и запусти:  ./install.sh --plasma"
  echo "(в niri всё уже настроено — можно сразу выбирать его на экране входа)"
fi
