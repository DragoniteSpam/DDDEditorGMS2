/// @param filename
/// @param [existing-mesh]

// SMF meshes will not return a collision shape, or a wireframe buffer.
// Hopefully the rest of the program can accomodate that.

var fn = argument[0];
var existing = (argument_count > 1 && argument[1] != undefined) ? argument[1] : noone;

var smf = smf_model_load(fn);

if (smf != undefined) {
    var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
    var base_name = filename_change_ext(filename_name(fn), "");
    
    // only do this if an existing mesh is not set
    if (!existing) {
        mesh.name = base_name;
        internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
    }
    
    proto_guid_set(mesh, ds_list_size(mesh.buffers));
    ds_list_add(mesh.buffers, smf[0]);
    ds_list_add(mesh.vbuffers, smf[1]);
    ds_list_add(mesh.wbuffers, noone);
    
    mesh.type = MeshTypes.SMF;
    
    data_smf_optimize_mesh(mesh, ds_list_size(mesh.vbuffers) - 1);
    
    return mesh;
}

return noone;