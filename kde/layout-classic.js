// Классическая раскладка KDE: панель задач внизу на каждом мониторе, закреплённые программы на ней же.
var LAUNCHERS = ["applications:firefox.desktop", "applications:org.telegram.desktop.desktop", "applications:discord.desktop", "applications:spotify.desktop", "applications:org.kde.dolphin.desktop", "applications:kitty.desktop", "applications:steam.desktop", "applications:obsidian.desktop", "applications:org.qbittorrent.qBittorrent.desktop", "applications:org.kde.kate.desktop", "applications:systemsettings.desktop"];
function set(w, g, k, v) { w.currentConfigGroup = g; w.writeConfig(k, v); }

// убираем все старые панели
panels().forEach(function (p) {
    p.remove();
});

for (var s = 0; s < screenCount; s++) {
    var p = new Panel("org.kde.panel");
    p.screen = s;
    p.location = "bottom";
    p.height = 44;
    p.floating = false;
    p.hiding = "none";

    p.addWidget("org.kde.plasma.kickoff");

    var t = p.addWidget("org.kde.plasma.taskmanager");     // окна с названиями, как в классике
    set(t, ["General"], "launchers", LAUNCHERS);
    set(t, ["General"], "showOnlyCurrentScreen", true);

    var hw = p.addWidget("org.kde.plasma.systemmonitor");
    set(hw, ["Appearance"], "chartFace", "org.kde.ksysguard.textonly");
    set(hw, ["Appearance"], "showTitle", false);
    set(hw, ["Sensors"], "highPrioritySensorIds",
        '["cpu/all/usage","cpu/all/averageTemperature","memory/physical/usedPercent"]');
    set(hw, ["SensorLabels"], "cpu/all/usage", "CPU");
    set(hw, ["SensorLabels"], "cpu/all/averageTemperature", "CPU°");
    set(hw, ["SensorLabels"], "memory/physical/usedPercent", "RAM");

    p.addWidget("org.kde.plasma.systemtray");
    var c = p.addWidget("org.kde.plasma.digitalclock");
    set(c, ["Appearance"], "use24hFormat", 2);
    set(c, ["Appearance"], "showDate", true);
    p.addWidget("org.kde.plasma.showdesktop");
}

panels().forEach(function (p) {
    print(p.screen + ":" + p.location + ":" + p.hiding + " ");
});
