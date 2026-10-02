#!/usr/bin/env python3
"""Глобальные сочетания клавиш KDE (как в niri). Назначаются через D-Bus KGlobalAccel (живёт внутри KWin),
поэтому KWin их сразу применяет и сам сохраняет в kglobalshortcutsrc."""
import subprocess

META, SHIFT, CTRL, ALT = 0x10000000, 0x02000000, 0x04000000, 0x08000000
KEYS = {"Return": 0x01000004, "Left": 0x01000012, "Up": 0x01000013, "Right": 0x01000014,
        "Down": 0x01000015, "Space": 0x20, "Print": 0x01000009, "Screensaver": 0x010000ba, "Tab": 0x01000001, "Del": 0x01000007,
        "F4": 0x01000033, "=": 0x3d, "-": 0x2d, "!": 0x21, "@": 0x40, "#": 0x23, "$": 0x24}
MODS = {"Meta": META, "Shift": SHIFT, "Ctrl": CTRL, "Alt": ALT}


def code(combo):
    *mods, key = combo.split("+")
    k = KEYS.get(key) or ord(key.upper())
    for m in mods:
        k |= MODS[m]
    return k


def call(method, *args):
    return subprocess.run(["gdbus", "call", "--session", "--dest", "org.kde.kglobalaccel",
                           "--object-path", "/kglobalaccel",
                           "--method", f"org.kde.KGlobalAccel.{method}", *args],
                          capture_output=True, text=True)


def setkeys(component, action, combos):
    aid = f"['{component}', '{action}', '', '']"
    if component.endswith(".desktop"):   # ярлыки программ могут быть ещё не зарегистрированы
        call("doRegister", f"['{component}', '{action}', '{component[:-8]}', '{action}']")
    seqs = ", ".join(f"([{code(c)}, 0, 0, 0],)" for c in combos)
    r = call("setForeignShortcutKeys", aid, f"@a(ai) [{seqs}]")
    status = "ok" if r.returncode == 0 else "ОШИБКА " + r.stderr.strip()
    print(f"  {component:30} {action:34} {', '.join(combos) or '—':30} {status}")


kw, ps = "kwin", "plasmashell"
S = [
    # --- то, чего в niri нет: освобождаем ---
    (kw, "Window Maximize", []), (kw, "Window Minimize", []),
    (kw, "Show Desktop", []),                       # Meta+D -> лаунчер
    (kw, "Switch One Desktop Up", []), (kw, "Switch One Desktop Down", []),
    (kw, "Switch Window Left", []), (kw, "Switch Window Right", []),
    (kw, "Switch Window Up", []), (kw, "Switch Window Down", []),
    ("systemsettings.desktop", "_launch", []),
    ("org.kde.spectacle.desktop", "_launch", []),                   # Print -> область
    # --- как в niri ---
    ("kitty.desktop", "_launch", ["Meta+Return"]),
    (kw, "Window Close", ["Meta+Q", "Alt+F4"]),
    ("ksmserver", "Log Out", ["Ctrl+Alt+Del"]),
    ("org.kde.dolphin.desktop", "_launch", ["Meta+E"]),
    ("firefox.desktop", "_launch", ["Meta+B"]),
    ("org.kde.krunner.desktop", "_launch", ["Meta+D", "Alt+Space"]),
    ("org.kde.spectacle.desktop", "RectangularRegionScreenShot", ["Print"]),
    (kw, "Window Fullscreen", ["Meta+F"]),
    ("ksmserver", "Lock Session", ["Meta+L", "Screensaver"]),
    (ps, "show-on-mouse-pos", ["Meta+V"]),
    (ps, "clear-history", ["Meta+Shift+V"]),
    ("pinky-wallpaper.desktop", "_launch", ["Meta+W"]),
    (kw, "Overview", ["Meta+O"]),
    # окна прилипают к половинам экрана (стандарт KDE)
    (kw, "Window Quick Tile Left", ["Meta+Left"]),
    (kw, "Window Quick Tile Right", ["Meta+Right"]),
    (kw, "Window Quick Tile Top", ["Meta+Up"]),
    (kw, "Window Quick Tile Bottom", ["Meta+Down"]),
    # рабочие столы и мониторы
    (kw, "Switch One Desktop to the Left", ["Meta+Ctrl+Left"]),
    (kw, "Switch One Desktop to the Right", ["Meta+Ctrl+Right"]),
    (kw, "Window to Next Screen", ["Meta+Alt+Right"]),
    (kw, "Window to Previous Screen", ["Meta+Alt+Left"]),
    # раскладка клавиатуры
    ("KDE Keyboard Layout Switcher", "Switch to Next Keyboard Layout", ["Meta+Space"]),
]
shifted = ["!", "@", "#", "$"]
for i in range(1, 5):
    S.append((ps, f"activate task manager entry {i}", []))
    S.append((kw, f"Switch to Desktop {i}", [f"Meta+{i}"]))
    S.append((kw, f"Window to Desktop {i}", [f"Meta+Shift+{i}", f"Meta+{shifted[i-1]}"]))

# сначала освобождаем, потом назначаем — иначе занятые сочетания не встанут
for comp, act, combos in sorted(S, key=lambda x: bool(x[2])):
    setkeys(comp, act, combos)
