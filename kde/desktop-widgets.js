// Виджеты рабочего стола (календарь, заметки, плеер) — только на тех мониторах, где их ещё нет
function set(w, g, k, v) { w.currentConfigGroup = g; w.writeConfig(k, v); }
var ds = desktopsForActivity(currentActivity());
for (var i = 0; i < ds.length; i++) {
    var d = ds[i];
    if (d.screen < 0 || d.widgets().length > 0) continue;
    var g = screenGeometry(d.screen), W = g.width, H = g.height;
    d.addWidget("org.kde.plasma.calendar", Math.round(W * 0.70), Math.round(H * 0.05), Math.round(W * 0.16), Math.round(H * 0.24));
    var notes = d.addWidget("org.kde.plasma.notes", Math.round(W * 0.70), Math.round(H * 0.33), Math.round(W * 0.14), Math.round(H * 0.24));
    set(notes, ["General"], "color", "translucent");
    d.addWidget("org.kde.plasma.mediacontroller", Math.round(W * 0.70), Math.round(H * 0.62), Math.round(W * 0.2), Math.round(H * 0.2));
}
