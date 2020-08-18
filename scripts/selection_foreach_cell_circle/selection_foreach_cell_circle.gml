/// @param selection
/// @param processed
/// @param script
/// @param params[]
function selection_foreach_cell_circle(argument0, argument1, argument2, argument3) {

	var selection = argument0;
	var processed = argument1;
	var script = argument2;
	var params = argument3;

	var minx = max(selection.x - selection.radius, 0);
	var miny = max(selection.y - selection.radius, 0);
	var maxx = min(selection.x + selection.radius, Stuff.map.active_map.xx - 1);
	var maxy = min(selection.y + selection.radius, Stuff.map.active_map.yy - 1);
	// no check for z - this only goes over cells in the layer that the that the selection exists on

	for (var i = minx; i < maxx; i++) {
	    for (var j = miny; j < maxy; j++) {
	        if (point_distance(selection.x, selection.y, i + 0.5, j + 0.5) < selection.radius) {
	            var str = string(i) + "," + string(j) + "," + string(selection.z);
	            if (!ds_map_exists(processed, str)) {
	                ds_map_add(processed, str, true);
	                script_execute(script, i, j, selection.z, params);
	            }
	        }
	    }
	}


}
