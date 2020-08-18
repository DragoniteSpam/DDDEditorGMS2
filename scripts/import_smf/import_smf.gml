/// @param filename
/// @param [existing-mesh]
/// @param [replace-index]
function import_smf() {

	// SMF meshes will not return a collision shape, or a wireframe buffer.
	// Hopefully the rest of the program can accomodate that.

	var fn = argument[0];
	var existing = (argument_count > 1 && argument[1] != undefined) ? argument[1] : noone;
	var replace_index = (argument_count > 2 && argument[2] != undefined) ? argument[2] : -1;

	var smf = smf_model_load(fn);

	if (smf != undefined) {
	    var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
	    mesh.type = MeshTypes.SMF;
	    var base_name = filename_change_ext(filename_name(fn), "");
    
	    // only do this if an existing mesh is not set
	    if (!existing) {
	        mesh.name = base_name;
	        internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
	    }
    
	    mesh_create_submesh(mesh, smf[0], smf[1], noone, undefined, base_name, replace_index, fn);
	    data_smf_optimize_mesh(mesh, ds_list_size(mesh.submeshes) - 1);
    
	    return mesh;
	}

	return noone;


}
