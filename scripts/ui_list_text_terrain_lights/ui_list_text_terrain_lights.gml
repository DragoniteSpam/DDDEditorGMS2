/// @param UIList
/// @param index
function ui_list_text_terrain_lights(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var light = list.entries[| index];

	switch (light.type) {
	    case LightTypes.NONE:
	        return "<disabled light>";
	    case LightTypes.POINT:
	        return "Point @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
	    case LightTypes.DIRECTIONAL:
	        return "Directional @ " + string(light.x) + "," + string(light.y) + "," + string(light.z);
	    case LightTypes.SPOT:
	        return "Spot @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
	}

	return "*";


}
