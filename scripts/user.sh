#!/usr/bin/env bash
# Pinky rice — файлы и настройки пользователя для KDE и niri (sudo не нужен, сеанс KDE не нужен).
# Обычно вызывается из ../install.sh
set -euo pipefail
R="$(cd "$(dirname "$0")/.." && pwd)"
BK=~/.cache/pinky-rice-backup-$(date +%F-%H%M); mkdir -p "$BK"
echo "==> Резервная копия текущих настроек: $BK"
for f in kdeglobals kwinrc kxkbrc kcminputrc kscreenlockerrc mimeapps.list niri waybar rofi dunst swaylock kitty fastfetch; do
  [ -e ~/.config/$f ] && cp -a ~/.config/$f "$BK/" || true
done

echo "==> Шрифт Terminus, курсор Мизуки, обои"
mkdir -p ~/.local/share/fonts/terminus ~/.local/share/icons ~/.local/share/wallpapers ~/.local/share/color-schemes
cp "$R"/fonts/*.ttf ~/.local/share/fonts/terminus/ && fc-cache -f >/dev/null
rm -rf ~/.local/share/icons/mizuki-psekai-cursor && cp -r "$R/icons/mizuki-psekai-cursor" ~/.local/share/icons/
cp "$R"/wallpapers/* ~/.local/share/wallpapers/
cp "$R/kde/StrawberryNight.colors" ~/.local/share/color-schemes/

echo "==> Иконки Papirus с розовыми папками (скачиваю из KDE Store)"
if [ ! -d ~/.local/share/icons/Papirus-Dark ]; then
  T=$(mktemp -d)
  url=$(curl -s 'https://api.kde-look.org/ocs/v1/content/data/1166289' | python3 -c "
import sys,re
s=sys.stdin.read()
for i,n in re.findall(r'<downloadname(\d+)>(.*?)</downloadname\d+>',s):
    if n=='papirus-icon-theme-pink-folders.tar.xz':
        print(re.search(r'<downloadlink%s>(.*?)</downloadlink%s>'%(i,i),s).group(1))")
  if [ -n "$url" ] && curl -sL -o "$T/p.tar.xz" "$url" && bsdtar -xf "$T/p.tar.xz" -C "$T"; then
    cp -a "$T"/Papirus "$T"/Papirus-Dark "$T"/Papirus-Light ~/.local/share/icons/
  else
    echo "   ! не удалось скачать — ставлю обычный Papirus из репозитория (папки будут синие)"
    sudo pacman -S --needed papirus-icon-theme
  fi
  rm -rf "$T"
fi

echo "==> Настройки KDE (цвета, шрифты, курсор, окна, раскладка)"
F="Terminus (TTF)"
w() { kwriteconfig6 "$@"; }
w --file kdeglobals --group General --key ColorScheme StrawberryNight
w --file kdeglobals --group Icons --key Theme Papirus-Dark
w --file kdeglobals --group General --key font                 "$F,15,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kdeglobals --group General --key menuFont             "$F,15,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kdeglobals --group General --key toolBarFont          "$F,14,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kdeglobals --group General --key smallestReadableFont "$F,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kdeglobals --group General --key fixed                "$F,15,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kdeglobals --group WM      --key activeFont           "$F,15,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
w --file kcminputrc --group Mouse --key cursorTheme mizuki-psekai-cursor
w --file kcminputrc --group Mouse --key cursorSize 32
w --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze
w --file kwinrc --group org.kde.kdecoration2 --key theme Breeze
w --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "M"
w --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"
w --file kwinrc --group Windows --key FocusPolicy FocusFollowsMouse
w --file kwinrc --group Windows --key DelayFocusInterval 150
w --file kwinrc --group Desktops --key Number 4
w --file kwinrc --group Desktops --key Rows 1
w --file kwinrc --group TabBox --key DesktopMode 0       # Alt+Tab по всем рабочим столам
w --file kwinrc --group TabBox --key MultiScreenMode 0
w --file kxkbrc --group Layout --key Use true
w --file kxkbrc --group Layout --key LayoutList us,ru
w --file kxkbrc --group Layout --key VariantList ","
w --file kxkbrc --group Layout --key ResetOldOptions true
w --file kxkbrc --group Layout --key Options ""
w --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General \
  --key Image "file://$HOME/.local/share/wallpapers/kanonbg-night.png"

echo "==> kitty и fastfetch"
mkdir -p ~/.config/kitty ~/.config/fastfetch
cp "$R/kde/kitty-pinky.conf" ~/.config/kitty/kitty-pinky.conf
touch ~/.config/kitty/kitty.conf
grep -q '^include kitty-pinky.conf' ~/.config/kitty/kitty.conf || printf '\ninclude kitty-pinky.conf\n' >> ~/.config/kitty/kitty.conf
cp "$R/kde/fastfetch.jsonc" ~/.config/fastfetch/config.jsonc

echo "==> Neovim: LazyVim в розовом стиле (C/C++, Python, Bash и др.)"
if [ -d ~/.config/nvim ] && [ ! -f ~/.config/nvim/lua/plugins/pinky.lua ]; then
  mv ~/.config/nvim "$BK/nvim-old"
fi
mkdir -p ~/.config/nvim && cp -a "$R/nvim/." ~/.config/nvim/
echo "   скачиваю плагины (1–2 минуты)..."
nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || true
echo "   ставлю языковые серверы, форматтеры и отладчики (несколько минут)..."
nvim --headless -c "Lazy! load mason.nvim" \
  -c "MasonInstall stylua shfmt codelldb cmakelang cmakelint markdownlint-cli2 markdown-toc shellcheck bash-language-server clang-format ruff debugpy tree-sitter-cli json-lsp pyright marksman clangd yaml-language-server taplo lua-language-server neocmakelsp" \
  -c qa >/dev/null 2>&1 || true

echo "==> niri: конфиги, бар, лаунчер, уведомления, блокировка"
for d in niri waybar rofi dunst swaylock; do
  mkdir -p ~/.config/$d && cp -a "$R/niri/config/$d/." ~/.config/$d/
done
sed -i "s#@HOME@#$HOME#g" ~/.config/swaylock/config
mkdir -p ~/.config/xdg-desktop-portal && cp "$R/niri/config/xdg-desktop-portal/niri-portals.conf" ~/.config/xdg-desktop-portal/
mkdir -p ~/.local/bin && install -m755 "$R"/niri/bin/pinky-* ~/.local/bin/
[ -f ~/.config/wallpaper ] || echo "$HOME/.local/share/wallpapers/kanonbg-night.png" > ~/.config/wallpaper
mkdir -p ~/Изображения/"Снимки экрана"

echo "==> Программы по умолчанию"
mkdir -p ~/.local/share/applications ~/.local/share/dbus-1/services
cp "$R/kde/nvim-kitty.desktop" ~/.local/share/applications/
cat > ~/.local/share/applications/pinky-wallpaper.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Сменить обои
Exec=$HOME/.local/bin/pinky-wallpaper
Icon=preferences-desktop-wallpaper
NoDisplay=true
EOF
# текстовые файлы и конфиги — в nvim (в kitty)
M=$(grep '^MimeType=' "$R/kde/nvim-kitty.desktop" | cut -d= -f2)
IFS=';' read -ra T <<< "$M"; xdg-mime default nvim-kitty.desktop "${T[@]}"
# папки: в KDE — Dolphin, в niri — Nautilus (и для «показать в папке»)
xdg-mime default org.kde.dolphin.desktop inode/directory
printf '[Default Applications]\ninode/directory=org.gnome.Nautilus.desktop\n' > ~/.config/niri-mimeapps.list
printf '[D-BUS Service]\nName=org.freedesktop.FileManager1\nExec=%s/.local/bin/pinky-filemanager1\n' "$HOME" \
  > ~/.local/share/dbus-1/services/org.freedesktop.FileManager1.service
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface accent-color 'pink' 2>/dev/null || true

# Happ: в niri стартует из startup.kdl (после бара, чтобы попасть в трей), обычный автозапуск — для KDE
if [ -f ~/.config/autostart/Happ.desktop ] && ! grep -q '^NotShowIn=' ~/.config/autostart/Happ.desktop; then
  echo 'NotShowIn=niri;' >> ~/.config/autostart/Happ.desktop
fi

update-desktop-database ~/.local/share/applications 2>/dev/null || true
kbuildsycoca6 >/dev/null 2>&1 || true
echo "Пользовательская часть готова."
