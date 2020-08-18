/// @param UIInput
function uivc_mesh_set_xmax(argument0) {

	var input = argument0;

	var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

	if (data) {
	    var old_value = data.xmax;
	    data.xmax = real(input.value);
	    if (old_value != data.xmax) {
	        data_mesh_recalculate_bounds(data);
	    }
	}


}
