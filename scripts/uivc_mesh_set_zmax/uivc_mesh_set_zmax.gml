/// @param UIInput
function uivc_mesh_set_zmax(argument0) {

	var input = argument0;

	var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

	if (data) {
	    var old_value = data.zmax;
	    data.zmax = real(input.value);
	    if (old_value != data.zmax) {
	        data_mesh_recalculate_bounds(data);
	    }
	}


}
