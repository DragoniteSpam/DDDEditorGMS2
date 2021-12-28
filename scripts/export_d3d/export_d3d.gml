function export_d3d(base_filename, mesh) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        export_d3d_raw(mesh_filename + number_ext + filename_ext(base_filename), mesh.submeshes[i].buffer);
    }
}

function export_d3d_raw(filename, buffer) {
    static export_buffer = buffer_create(1024, buffer_grow, 1);
    buffer_seek(export_buffer, buffer_seek_start, 0);
    buffer_seek(buffer, buffer_seek_start, 0);
    
    buffer_write(export_buffer, buffer_text, "100\r\n");
    buffer_write(export_buffer, buffer_text, string((buffer_get_size(buffer) / VERTEX_SIZE) + 2) + "\r\n");
    buffer_write(export_buffer, buffer_text, "0 4\r\n");
    
    for (var i = 0, n = buffer_get_size(buffer); i < n; i += VERTEX_SIZE) {
        var xx = buffer_peek(buffer, i + 00, buffer_f32);
        var yy = buffer_peek(buffer, i + 04, buffer_f32);
        var zz = buffer_peek(buffer, i + 08, buffer_f32);
        var nx = buffer_peek(buffer, i + 12, buffer_f32);
        var ny = buffer_peek(buffer, i + 16, buffer_f32);
        var nz = buffer_peek(buffer, i + 20, buffer_f32);
        var xt = buffer_peek(buffer, i + 24, buffer_f32);
        var yt = buffer_peek(buffer, i + 28, buffer_f32);
        var cc = buffer_peek(buffer, i + 32, buffer_u32);
        
        buffer_write(export_buffer, buffer_text, "9 " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) +
            " " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + " " + decimal(xt) + " " +
            decimal(yt) + " " + decimal(cc & 0xffffff) + " " + decimal(((cc >> 24) & 0xff) / 0xff) + "\r\n"
        );
    }
    
    buffer_write(export_buffer, buffer_text, "1\r\n");
    buffer_save_ext(export_buffer, filename, 0, buffer_tell(export_buffer));
}