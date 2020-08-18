/// @param DataMesh
/// @param scale
function mesh_set_all_scale(argument0, argument1) {

	var mesh = argument0;
	var scale = argument1;

	for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
	    mesh_set_scale(mesh, i, scale);
	}


}
