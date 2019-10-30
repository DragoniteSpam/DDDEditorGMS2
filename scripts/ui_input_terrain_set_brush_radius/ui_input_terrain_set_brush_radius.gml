/// @param UIRProgressBar

var bar = argument0;

Stuff.terrain.radius = normalize_correct(bar.value, Stuff.terrain.brush_min, Stuff.terrain.brush_max, 0, 1);
bar.root.element_brush_radius.text = "Brush radius:" + string(Stuff.terrain.radius) + " cells";