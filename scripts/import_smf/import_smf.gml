/// @param filename

// SMF meshes will not return a collision shape, or a wireframe buffer.
// Hopefully the rest of the program can accomodate that.

var fn = argument[0];

var smf = smf_model_load(fn);

if (smf != undefined) {
	var mesh = instance_create_depth(0, 0, 0, DataMesh);
	
	var base_name = filename_change_ext(filename_name(fn), "");
	mesh.name = base_name;
	var internal_name = "Ms" + string_lettersdigits(base_name);
	while (internal_name_get(internal_name)) {
	    internal_name = "Ms" + string_lettersdigits(base_name) + string(irandom(65535));
	}
	internal_name_set(mesh, internal_name);
	mesh.buffer = smf[0];
	mesh.vbuffer = smf[1];
    
    mesh.type = MeshTypes.SMF;
    
    data_smf_optimize_mesh(mesh);
	
	return mesh;
}

return noone;