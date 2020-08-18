/// @param UIList
/// @param x
/// @param y
function ui_render_list_event_custom_set_data(argument0, argument1, argument2) {

	var list = argument0;
	var xx = argument1;
	var yy = argument2;

	// not sure what's with "type.type" but
	list.entries = (list.type.type == DataTypes.ENUM) ? list.type.properties : list.type.instances;

	ui_render_list(list, xx, yy);


}
