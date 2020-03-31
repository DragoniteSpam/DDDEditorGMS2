/// @param fname

var fn = argument0;

var buffer = buffer_create(1024, buffer_grow, 4);

var data = ds_map_create();
data[? "version"] = 1;
// @todo not hard-coding this
data[? "grid_size"] = 32;

buffer_write_string(buffer, ds_map_write(data));
ds_map_destroy(data);

var n_meshes = ds_list_size(Stuff.all_meshes);
buffer_write(buffer, buffer_f32, n_meshes);

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    buffer_write_string(buffer, mesh.name);
    
    buffer_seek(mesh.buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_u32, buffer_get_size(mesh.buffer));
    buffer_write_buffer(buffer, mesh.buffer);
    
    // grid_size is hard-coded to 32 because i can't be bothered to do it properly
    buffer_write(buffer, buffer_f32, mesh.xmin);
    buffer_write(buffer, buffer_f32, mesh.ymin);
    buffer_write(buffer, buffer_f32, mesh.zmin);
    buffer_write(buffer, buffer_f32, mesh.xmax);
    buffer_write(buffer, buffer_f32, mesh.ymax);
    buffer_write(buffer, buffer_f32, mesh.zmax);
}

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);