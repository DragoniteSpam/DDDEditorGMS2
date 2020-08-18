/// @param UIList
/// @param index
function ui_list_color_effect_components(argument0, argument1) {

	var list = argument0;
	var index = argument1;

	var effect = refid_get(list.entries[| index]);

	if (!effect) {
	    return c_black;
	}

	for (var i = 0; i < ds_list_size(list.entries); i++) {
	    if (i == index) continue;
	    if (list.entries[| i] == list.entries[| index]) return c_orange;
	}

	return effect.com_light ? effect.com_light.label_colour : c_red;


}
