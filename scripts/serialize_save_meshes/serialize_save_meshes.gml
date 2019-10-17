/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MESHES);

var n_meshes = ds_list_size(Stuff.all_meshes);
buffer_write(buffer, buffer_u32, n_meshes);

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    
    serialize_save_generic(buffer, mesh);
    
    buffer_write(buffer, buffer_u8, mesh.type);
    
    buffer_write(buffer, buffer_u32, buffer_get_size(mesh.buffer));
    buffer_write_buffer(buffer, mesh.buffer);
    // don't bother saving the wireframe buffer - we need to re-create the collision
    // shape as well, so we might as well recreate the wireframe at the same time :/
    
    buffer_write(buffer, buffer_f32, mesh.xmin);
    buffer_write(buffer, buffer_f32, mesh.ymin);
    buffer_write(buffer, buffer_f32, mesh.zmin);
    buffer_write(buffer, buffer_f32, mesh.xmax);
    buffer_write(buffer, buffer_f32, mesh.ymax);
    buffer_write(buffer, buffer_f32, mesh.zmax);
    
    buffer_write(buffer, buffer_u8, mesh.passage);
    buffer_write(buffer, buffer_u8, mesh.tags);
}