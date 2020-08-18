/// @param EventNode
/// @param index
function event_prefab_render_input_type_name(argument0, argument1) {

	var event = argument0;
	var index = argument1;

	// @gml update
	var custom_data = event.custom_data[| 2];
	var raw = custom_data[| 0];

	switch (raw) {
	    case 0: return "Text";
	    case 1: return "Text (Scribble safe)";
	    case 2: return "Integer";
	    case 3: return "Unsigned Integer";
	    case 4: return "Floating Point";
	}

	return "?";


}
