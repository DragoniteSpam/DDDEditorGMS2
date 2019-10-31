/// @param UIRProgressBar

var bar = argument0;

var value = clamp(round_ext(normalize_correct(bar.value, Stuff.terrain.paint_precision_min, Stuff.terrain.paint_precision_max, 0, 1), 8), 1, 0xff);
Stuff.terrain.paint_precision = value;
bar.value = normalize_correct(value, 0, 1, Stuff.terrain.paint_precision_min, Stuff.terrain.paint_precision_max);
bar.root.element_paint_precision.text = "Paint precision: " + string(Stuff.terrain.paint_precision);