function export_vb(base_filename, mesh, format_type) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        
        var formatted_buffer = mesh.submeshes[i].GetExportedBuffer(format_type);
        buffer_save(formatted_buffer, fn);
        
        if (formatted_buffer != mesh.submeshes[i].buffer) {
            buffer_delete(formatted_buffer);
        }
    }
}