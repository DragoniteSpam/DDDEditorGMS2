/// @param EventNode
/// @param index
function event_prefab_render_switch_name(argument0, argument1) {

	var event = argument0;
	var index = argument1;

	// @gml update
	var custom_data = event.custom_data[| 0];
	var raw = custom_data[| 0];

	if (!is_clamped(raw, 0, ds_list_size(Stuff.switches))) {
	    return "n/a";
	}

	var data = Stuff.switches[| raw];
	return data[0];


}
