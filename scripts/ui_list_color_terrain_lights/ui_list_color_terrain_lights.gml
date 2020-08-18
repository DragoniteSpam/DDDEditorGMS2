/// @param UIList
/// @param index
function ui_list_color_terrain_lights(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var light = list.entries[| index];

	return (light.type == LightTypes.SPOT || light.type == LightTypes.NONE) ? c_gray : c_black;


}
