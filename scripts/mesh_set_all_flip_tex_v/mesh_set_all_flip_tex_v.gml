/// @param DataMesh
function mesh_set_all_flip_tex_v(argument0) {

	var mesh = argument0;

	for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
	    mesh_set_flip_tex_v(mesh, i);
	}


}
