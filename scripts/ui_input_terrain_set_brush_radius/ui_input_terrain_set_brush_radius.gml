/// @param UIRProgressBar
function ui_input_terrain_set_brush_radius(argument0) {

	var bar = argument0;

	Stuff.terrain.radius = normalize_correct(bar.value, Stuff.terrain.brush_min, Stuff.terrain.brush_max, 0, 1);
	bar.root.element_brush_radius.text = "Brush radius: " + string(Stuff.terrain.radius) + " cells";


}
