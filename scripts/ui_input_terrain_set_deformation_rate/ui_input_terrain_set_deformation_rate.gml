/// @param UIRProgressBar

var bar = argument0;

Stuff.terrain.rate = normalize_correct(bar.value, Stuff.terrain.rate_min, Stuff.terrain.rate_max, 0, 1);
bar.root.element_rate.text = "Deformation rate: " + string_format(Stuff.terrain.rate, 1, 3);