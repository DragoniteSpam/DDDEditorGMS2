/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

ds_list_clear_instances(Stuff.all_meshes);

var n_meshes = buffer_read(buffer, buffer_u32);

repeat (n_meshes) {
    var mesh = instance_create_depth(0, 0, 0, DataMesh);
    serialize_load_generic(buffer, mesh, version);
    
    mesh.type = buffer_read(buffer, buffer_u8);
    
    if (version >= DataVersions.MESHES_OVERHAULED_AGAIN_PROBABLY) {
        var n_submeshes = buffer_read(buffer, buffer_u16);
        for (var i = 0; i < n_submeshes; i++) {
            var index = buffer_read(buffer, buffer_u16);
            var proto_guid = buffer_read(buffer, buffer_datatype);
            var blength = buffer_read(buffer, buffer_u32);
            mesh.buffers[| index] = buffer_read_buffer(buffer, blength);
            proto_guid_set(mesh, i, proto_guid);
        }
    } else {
        var size = buffer_read(buffer, buffer_u32);
        proto_guid_set(mesh, 0);
        ds_list_add(mesh.buffers, buffer_read_buffer(buffer, size));
    }
    
    mesh.xmin = buffer_read(buffer, buffer_f32);
    mesh.ymin = buffer_read(buffer, buffer_f32);
    mesh.zmin = buffer_read(buffer, buffer_f32);
    mesh.xmax = buffer_read(buffer, buffer_f32);
    mesh.ymax = buffer_read(buffer, buffer_f32);
    mesh.zmax = buffer_read(buffer, buffer_f32);
    
    if (version >= DataVersions.DETAILED_MESH_COLLISION_DATA) {
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var zz = buffer_read(buffer, buffer_u16);
        ds_grid_resize(mesh.collision_flags, xx, yy);
        for (var i = 0; i < xx; i++) {
            for (var j = 0; j < yy; j++) {
                var slice = array_create(zz);
                mesh.collision_flags[# i, j] = slice;
                for (var k = 0; k < zz; k++) {
                    slice[@ k] = buffer_read(buffer, buffer_u32);
                }
            }
        }
    } else {
        data_mesh_recalculate_bounds(mesh);
    }
    
    if (version >= DataVersions.DETAILED_MESH_COLLISION_DATA) {
    } else if (version >= DataVersions.REMOVE_RMXP_DATA) {
        buffer_read(buffer, buffer_u8);
    } else {
        buffer_read(buffer, buffer_u8);
    }
    if (version >= DataVersions.NEW_TERRAIN_FLAGS) {
    } else {
        buffer_read(buffer, buffer_u8);
    }
    
    if (version >= DataVersions.ASSET_MARKERS) {
        mesh.marker = buffer_read(buffer, buffer_u32);
    }
    // flags are saved in save_generic
    
    switch (mesh.type) {
        case MeshTypes.RAW: serialize_load_mesh_raw(mesh); break;
        case MeshTypes.SMF: serialize_load_mesh_smf(mesh); break;
    }
}