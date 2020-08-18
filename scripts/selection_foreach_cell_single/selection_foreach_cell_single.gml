/// @param selection
/// @param processed
/// @param script
/// @param params[]
function selection_foreach_cell_single(argument0, argument1, argument2, argument3) {

	var selection = argument0;
	var processed = argument1;
	var script = argument2;
	var params = argument3;

	var str = string(selection.x) + "," + string(selection.y) + "," + string(selection.z);

	if (!ds_map_exists(processed, str)) {
	    ds_map_add(processed, str, true);
	    script_execute(script, selection.x, selection.y, selection.z, params);
	}


}
