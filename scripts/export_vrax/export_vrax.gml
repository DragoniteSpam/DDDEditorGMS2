/// @param fname

var fn = argument0;

var buffer = buffer_create(1024, buffer_grow, 4);

var data = ds_map_create();
data[? "version"] = 1;
data[? "grid_size"] = 32;

buffer_write_string(buffer, ds_map_write(data));
ds_map_destroy(data);

var n_meshes = ds_list_size(Stuff.all_meshes);
buffer_write(buffer, T, n_meshes);

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    buffer_write_string(buffer, mesh.name);
    
    var n_vertices = buffer_get_size(mesh.buffer) / VERTEX_FORMAT_SIZE;
    buffer_write(buffer, T, n_vertices);
    
    buffer_seek(mesh.buffer, buffer_seek_start, 0);
    
    while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // x
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // y
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // z
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // nx
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // ny
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32));   // nz
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32) / TILESET_TEXTURE_WIDTH);   // xtex
        buffer_write(buffer, T, buffer_read(mesh.buffer, buffer_f32) / TILESET_TEXTURE_HEIGHT);   // ytex
        var color = buffer_read(mesh.buffer, buffer_u32);
        buffer_write(buffer, T, color & 0xffffff);   // color
        buffer_write(buffer, T, (color & 0xff000000) >> 24);   // alpha
        buffer_read(mesh.buffer, buffer_u32);
    }
    
    // grid_size is hard-coded to 32 because i can't be bothered to do it properly
    buffer_write(buffer, T, mesh.xmin);
    buffer_write(buffer, T, mesh.ymin);
    buffer_write(buffer, T, mesh.zmin);
    buffer_write(buffer, T, mesh.xmax);
    buffer_write(buffer, T, mesh.ymax);
    buffer_write(buffer, T, mesh.zmax);
    
    buffer_seek(mesh.buffer, buffer_seek_start, 0);
}

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);