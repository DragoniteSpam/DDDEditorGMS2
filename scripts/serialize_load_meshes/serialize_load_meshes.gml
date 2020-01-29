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
    
    var size = buffer_read(buffer, buffer_u32);
    mesh.buffer = buffer_read_buffer(buffer, size);
    mesh.vbuffer = vertex_create_buffer_from_buffer(mesh.buffer, Stuff.graphics.vertex_format);
    
    mesh.cshape = c_shape_create();
    c_shape_begin_trimesh();
    mesh.wbuffer = vertex_create_buffer();
    vertex_begin(mesh.wbuffer, Stuff.graphics.vertex_format);
    
    mesh.xmin = buffer_read(buffer, buffer_f32);
    mesh.ymin = buffer_read(buffer, buffer_f32);
    mesh.zmin = buffer_read(buffer, buffer_f32);
    mesh.xmax = buffer_read(buffer, buffer_f32);
    mesh.ymax = buffer_read(buffer, buffer_f32);
    mesh.zmax = buffer_read(buffer, buffer_f32);
    
    if (version >= DataVersions.DETAILED_MESH_COLLISION_DATA) {
    } else {
        data_mesh_recalculate_bounds(mesh);
    }
    
    if (version >= DataVersions.REMOVE_RMXP_DATA) {
        buffer_read(buffer, buffer_u8);
    } else {
        buffer_read(buffer, buffer_u8);
    }
    if (version >= DataVersions.NEW_TERRAIN_FLAGS) {
    } else {
        buffer_read(buffer, buffer_u8);
    }
    // flags are saved in save_generic
    
    switch (mesh.type) {
        case MeshTypes.RAW: serialize_load_mesh_raw(mesh); break;
        case MeshTypes.SMF: serialize_load_mesh_smf(mesh); break;
    }
    
    buffer_seek(mesh.buffer, buffer_seek_start, 0);
}