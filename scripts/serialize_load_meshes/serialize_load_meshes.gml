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
    
    var n_submeshes = buffer_read(buffer, buffer_u16);
    for (var i = 0; i < n_submeshes; i++) {
        var index = buffer_read(buffer, buffer_u16);
        var proto_guid = buffer_read(buffer, buffer_get_datatype(version));
        var blength = buffer_read(buffer, buffer_u32);
        var name = buffer_read(buffer, buffer_string);
        if (version >= DataVersions.EVEN_MORE_MESH_METADATA) {
            var path = buffer_read(buffer, buffer_string);
        }
        var dbuffer = buffer_read_buffer(buffer, blength);
        mesh_create_submesh(mesh, dbuffer, noone, noone, proto_guid, name);
    }
    
    mesh.xmin = buffer_read(buffer, buffer_f32);
    mesh.ymin = buffer_read(buffer, buffer_f32);
    mesh.zmin = buffer_read(buffer, buffer_f32);
    mesh.xmax = buffer_read(buffer, buffer_f32);
    mesh.ymax = buffer_read(buffer, buffer_f32);
    mesh.zmax = buffer_read(buffer, buffer_f32);
    
    if (version >= DataVersions.EVEN_MORE_MESH_METADATA) {
        mesh.texture_scale = buffer_read(buffer, buffer_f32);
    }
    
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
    
    mesh.marker = buffer_read(buffer, buffer_u32);
    
    // flags are saved in save_generic
    
    switch (mesh.type) {
        case MeshTypes.RAW: serialize_load_mesh_raw(mesh); break;
        case MeshTypes.SMF: serialize_load_mesh_smf(mesh); break;
    }
}