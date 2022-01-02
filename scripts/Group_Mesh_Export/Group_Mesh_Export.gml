function export_vb(base_filename, mesh, format_type) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        
        var formatted = vertex_buffer_formatted(mesh.submeshes[i].buffer, format_type);
        buffer_save(formatted, fn);
        buffer_delete(formatted);
    }
}

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

function export_obj(base_filename, mesh, title = "DDD") {
    var path = filename_path(base_filename);
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    var buffer = buffer_create(1024, buffer_grow, 1);
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var sub = mesh.submeshes[i];
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        buffer_seek(sub.buffer, buffer_seek_start, 0);
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_text, "# " + title + "\r\n");
        buffer_write(buffer, buffer_text, "mtllib " + filename_name(filename_name(filename_change_ext(fn, ".mtl"))) + "\r\n\r\n");
        
        var active_mtl = "None";
        var mtl_alpha = { };
        var mtl_r = { };
        var mtl_g = { };
        var mtl_b = { };
        
        var cc = [0xffffffff, 0xffffffff, 0xffffffff];
        var xx, yy, zz, nx, ny, nz, xtex, ytex;
        
        var face_index = 1;
        
        for (var j = 0, n = buffer_get_size(sub.buffer); j < n; j += VERTEX_SIZE * 3) {
            for (var k = 0; k < 3; k++) {
                xx =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 00, buffer_f32);
                yy =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 04, buffer_f32);
                zz =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 08, buffer_f32);
                nx =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 12, buffer_f32);
                ny =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 16, buffer_f32);
                nz =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 20, buffer_f32);
                xt =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 24, buffer_f32);
                yt =    buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 28, buffer_f32);
                cc[k] = buffer_peek(sub.buffer, j + k * VERTEX_SIZE + 32, buffer_u32);
                
                buffer_write(buffer, buffer_text, "v " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) + "\r\n");
                buffer_write(buffer, buffer_text, "vt " + decimal(xt) + " " + decimal(yt) + "\r\n");
                buffer_write(buffer, buffer_text, "vn " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + "\r\n");
            }
            
            // meh
            var c = floor(cc[0] & 0xffffff);
            var a = (((cc[0] & 0xff000000) >> 24) + ((cc[1] & 0xff000000) >> 24) + ((cc[2] & 0xff000000) >> 24)) / 3;
            
            // this may need updating if materials are dealt with properly later
            var mtl_name = string(floor((cc[0] + cc[1] + cc[2]) / 4));
            
            if (!variable_struct_exists(mtl_alpha, mtl_name)) {
                mtl_alpha[$ mtl_name] = a / 0xff;
                mtl_r[$ mtl_name] = (c & 0x0000ff) / 0xff;
                mtl_g[$ mtl_name] = ((c & 0x00ff00) >> 8) / 0xff;
                mtl_b[$ mtl_name] = ((c & 0xff0000) >> 16) / 0xff;
            }
            
            active_mtl = mtl_name;
            
            if (string_length(active_mtl) > 0) {
                buffer_write(buffer, buffer_text, "usemtl " + active_mtl + "\r\n");
            }
            
            var text1 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            var text2 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            var text3 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            buffer_write(buffer, buffer_text, "f " + text1 + " " + text2 + " " + text3 + "\r\n\r\n");
        }
        
        buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_text, "# DDD MTL file\r\n");
        buffer_write(buffer, buffer_text, "# Material count: " + string(variable_struct_names_count(mtl_alpha)) + "\r\n");
        
        var keys = variable_struct_get_names(mtl_alpha);
        for (var k = 0; k < array_length(keys); k++) {
            var mtl = keys[i];
            buffer_write(buffer, buffer_text, "\r\nnewmtl " + mtl + "\r\n");
            buffer_write(buffer, buffer_text, "Kd " + string(mtl_r[$ mtl]) + " " + string(mtl_g[$ mtl]) + " " + string(mtl_b[$ mtl]) + "\r\n");
            buffer_write(buffer, buffer_text, "d " + string(mtl_alpha[$ mtl]) + "\r\n");
            buffer_write(buffer, buffer_text, "illum 2\r\n");
            
            // there are a lot of texture maps that may or may not need to be used
            if (mesh.tex_base != NULL) buffer_write(buffer, buffer_text, "map_Kd " + string_filename(guid_get(mesh.tex_base).name) + ".png\r\n");
            if (mesh.tex_ambient != NULL) buffer_write(buffer, buffer_text, "map_Ka " + string_filename(guid_get(mesh.tex_ambient).name) + ".png\r\n");
            if (mesh.tex_specular_color != NULL) buffer_write(buffer, buffer_text, "map_Ks " + string_filename(guid_get(mesh.tex_specular_color).name) + ".png\r\n");
            if (mesh.tex_specular_highlight != NULL) buffer_write(buffer, buffer_text, "map_Ns " + string_filename(guid_get(mesh.tex_specular_highlight).name) + ".png\r\n");
            if (mesh.tex_alpha != NULL) buffer_write(buffer, buffer_text, "map_d " + string_filename(guid_get(mesh.tex_alpha).name) + ".png\r\n");
            if (mesh.tex_bump != NULL) buffer_write(buffer, buffer_text, "map_bump " + string_filename(guid_get(mesh.tex_bump).name) + ".png\r\n");
            if (mesh.tex_displacement != NULL) buffer_write(buffer, buffer_text, "map_disp " + string_filename(guid_get(mesh.tex_displacement).name) + ".png\r\n");
            if (mesh.tex_stencil != NULL) buffer_write(buffer, buffer_text, "map_decal " + string_filename(guid_get(mesh.tex_stencil).name) + ".png\r\n");
        }
        
        buffer_save_ext(buffer, filename_change_ext(fn, ".mtl"), 0, buffer_tell(buffer));
        // sigh
        
        if (mesh.tex_base != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_base).name) + ".png");
        if (mesh.tex_ambient != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_ambient).name) + ".png");
        if (mesh.tex_specular_color != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_specular_color).name) + ".png");
        if (mesh.tex_specular_highlight != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_specular_highlight).name) + ".png");
        if (mesh.tex_alpha != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_alpha).name) + ".png");
        if (mesh.tex_bump != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_bump).name) + ".png");
        if (mesh.tex_displacement != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_displacement).name) + ".png");
        if (mesh.tex_stencil != NULL) sprite_save(guid_get(mesh.tex_base).picture, 0, path + string_filename(guid_get(mesh.tex_stencil).name) + ".png");
    }
    
    buffer_delete(buffer);
}