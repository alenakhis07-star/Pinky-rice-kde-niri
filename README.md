# Pinky rice ♡ KDE Plasma + niri

Тёмно-розовое оформление для **CachyOS / Arch**: KDE Plasma и niri в одном стиле,
плюс няшный экран входа SDDM, где можно выбрать любой из двух сеансов.

![экран входа](docs/sddm.png)

## Установка

```bash
git clone git@github.com:alenakhis07-star/Pinky-rice-kde-niri.git
cd Pinky-rice-kde-niri
./install.sh
```

Скрипт попросит пароль sudo (для пакетов и экрана входа). Дальше:

1. Перезагрузись.
2. На экране входа выбери **Plasma (Wayland)** и запусти в терминале `./install.sh --plasma`. Это применит тему, панели и сочетания клавиш KDE.
3. niri уже настроен — просто выбери **Niri** на экране входа.

Если оформление KDE когда-нибудь слетит (например, случайно сменилась глобальная тема) — снова `./install.sh --plasma`.

| Команда | Что делает |
|---|---|
| `./install.sh` | всё: пакеты, настройки, и если ты уже в KDE — сразу оформление |
| `./install.sh --user` | только файлы и настройки, без пакетов и sudo |
| `./install.sh --plasma` | только оформление KDE (внутри сеанса Plasma) |
| `./install.sh --xbox-dns` | только [Xbox DNS](https://xbox-dns.ru) с шифрованием DNS-over-TLS (выключить: `bash scripts/xbox-dns.sh --off`) |

Перед изменениями текущие настройки копируются в `~/.cache/pinky-rice-backup-…`.


## Сочетания клавиш (одинаковые в KDE и niri)

| Клавиши | Действие |
|---|---|
| Super+Enter / E / B / D | kitty / файлы / Firefox / запуск программ |
| Super+Q | закрыть окно |
| Super+F | во весь экран (в niri Ctrl+Super+F — развернуть до краёв) |
| Super+L | заблокировать |
| Super+V / Super+Shift+V | история буфера / очистить |
| Super+W | следующие обои |
| Super+Space | раскладка |
| Super+1…4, Super+Shift+1…4 | рабочий стол / перенести окно туда |
| Super+Ctrl+←/→ | KDE: соседний рабочий стол · niri: прошлое окно и обратно |
| Super+Tab (niri) | прошлый рабочий стол и обратно |
| Super+PgUp/PgDn (niri) | прошлое окно и обратно |
| Super+Ctrl+↑/↓ (niri) | соседний рабочий стол |
| Super+колесо / Super+Shift+колесо (niri) | окна / рабочие столы |
| Print | скриншот области |
| Ctrl+Alt+Del | меню сеанса (niri) / выход (KDE) |

Только в niri: Super+стрелки — фокус, Super+Alt+стрелки — двигать окна, Super+Shift+стрелки — другой монитор, Ctrl+Super+Shift+стрелки — перенести окно на другой монитор, Super+P — меню сеанса, Super+T — сделать окно плавающим и обратно, Super+C — окно по центру, Super+O — обзор, Super+Shift+/ — все сочетания.

## Neovim (LazyVim)

Ставится вместе со всем остальным: [LazyVim](https://github.com/LazyVim/LazyVim) в тех же розовых цветах, с прозрачным фоном kitty.

- автодополнение с документацией и подсказками аргументов, ошибки прямо в коде, форматирование при сохранении
- C/C++ (clangd, clang-format, отладчик codelldb), Python (pyright, ruff, debugpy), Bash (bashls, shellcheck, shfmt), CMake, Lua, JSON, YAML, TOML, Markdown
- `<пробел>r` — собрать и запустить текущий файл (Python, C, C++, Bash, Lua) в терминале снизу: можно вводить данные, окно закрывается на `q`
- команды работают и в русской раскладке
- `<пробел>` — меню всех команд (which-key), `<пробел>e` — дерево файлов, `<пробел>ff` — поиск файла, `<пробел>sg` — поиск по тексту, `gd` — к определению, `K` — документация

## Благодарности

- обои и цветовая схема-основа — [u/Commercial_Tap9279](https://www.reddit.com/r/unixporn/comments/1wpidy7/kde_plasma_my_pinky_linux_theme_3/)
- конфиги niri — [revaljonathan/val-niri](https://github.com/revaljonathan/val-niri)
- тема SDDM — [Keyitdev/sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) (GPL-3.0)
- курсор Мизуки — из [lezzthanthree/amiArch-Mizoox](https://github.com/lezzthanthree/amiArch-Mizoox)
- иконки — [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (розовые папки — [KDE Store](https://store.kde.org/p/1166289))
- редактор — [LazyVim](https://github.com/LazyVim/LazyVim)
- шрифт — [Terminus TTF](https://files.ax86.net/terminus-ttf/) (SIL OFL)
