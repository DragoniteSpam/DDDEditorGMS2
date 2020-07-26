/// @param fname
/// @param DataMesh

var base_filename = argument0;
var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
var mesh = argument1;
var buffer = buffer_create(1024, buffer_grow, 1);

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var number_ext = (ds_list_size(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
    var sub = mesh.submeshes[| i];
    var fn = mesh_filename + number_ext + filename_ext(base_filename);
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_seek(sub.buffer, buffer_seek_start, 0);
    
    buffer_write(buffer, buffer_text, "100\r\n");
    buffer_write(buffer, buffer_text, string((buffer_get_size(sub.buffer) / VERTEX_SIZE) + 2) + "\r\n");
    buffer_write(buffer, buffer_text, "0 4\r\n");

    while (buffer_tell(sub.buffer) < buffer_get_size(sub.buffer)) {
        var xx = buffer_read(sub.buffer, buffer_f32);
        var yy = buffer_read(sub.buffer, buffer_f32);
        var zz = buffer_read(sub.buffer, buffer_f32);
        var nx = buffer_read(sub.buffer, buffer_f32);
        var ny = buffer_read(sub.buffer, buffer_f32);
        var nz = buffer_read(sub.buffer, buffer_f32);
        var xtex = buffer_read(sub.buffer, buffer_f32) / mesh.texture_scale;
        var ytex = buffer_read(sub.buffer, buffer_f32) / mesh.texture_scale;
        var color = buffer_read(sub.buffer, buffer_u32);
        buffer_read(sub.buffer, buffer_u32);
    
        buffer_write(buffer, buffer_text, "9 " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) +
            " " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + " " + decimal(xtex) + " " +
            decimal(ytex) + " " + decimal(color & 0xffffff) + " " + decimal(((color >> 24) & 0xff) / 255) + "\r\n"
        );
    }

    buffer_write(buffer, buffer_text, "1\r\n");
    buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
}

buffer_delete(buffer);