function export_d3d(base_filename, mesh) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var number_ext = (ds_list_size(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        export_d3d_raw(mesh_filename + number_ext + filename_ext(base_filename), mesh.submeshes[| i].buffer);
    }
}

function export_d3d_raw(filename, buffer) {
    static export_buffer = buffer_create(1024, buffer_grow, 1);
    buffer_seek(export_buffer, buffer_seek_start, 0);
    buffer_seek(buffer, buffer_seek_start, 0);
    
    buffer_write(export_buffer, buffer_text, "100\r\n");
    buffer_write(export_buffer, buffer_text, string((buffer_get_size(buffer) / VERTEX_SIZE) + 2) + "\r\n");
    buffer_write(export_buffer, buffer_text, "0 4\r\n");
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var xx = buffer_read(buffer, buffer_f32);
        var yy = buffer_read(buffer, buffer_f32);
        var zz = buffer_read(buffer, buffer_f32);
        var nx = buffer_read(buffer, buffer_f32);
        var ny = buffer_read(buffer, buffer_f32);
        var nz = buffer_read(buffer, buffer_f32);
        var xtex = buffer_read(buffer, buffer_f32);
        var ytex = buffer_read(buffer, buffer_f32);
        var color = buffer_read(buffer, buffer_u32);
        buffer_read(buffer, buffer_u32);
        
        buffer_write(export_buffer, buffer_text, "9 " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) +
            " " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + " " + decimal(xtex) + " " +
            decimal(ytex) + " " + decimal(color & 0xffffff) + " " + decimal(((color >> 24) & 0xff) / 255) + "\r\n"
        );
    }
    
    buffer_write(export_buffer, buffer_text, "1\r\n");
    buffer_save_ext(export_buffer, filename, 0, buffer_tell(export_buffer));
}