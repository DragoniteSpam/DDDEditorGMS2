/// @param UIColorPicker
function ui_input_terrain_set_paint_color(argument0) {

	var picker = argument0;

	Stuff.terrain.paint_color = picker.value | (floor(picker.alpha * 255) << 24);


}
