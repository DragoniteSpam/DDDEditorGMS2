function export_vb(base_filename, mesh, format_type) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("_" + mesh.submeshes[i].name);
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        
        var formatted = meshops_vertex_formatted(mesh.submeshes[i].buffer, format_type);
        buffer_save(formatted, fn);
        buffer_delete(formatted);
    }
}

function export_d3d(base_filename, mesh) {
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("_" + mesh.submeshes[i].name);
        meshops_export_d3d(mesh_filename + number_ext + filename_ext(base_filename), mesh.submeshes[i].buffer);
    }
}

function export_obj(base_filename, mesh, title = "Generated by DDD/Penguin: https://dragonite.itch.io/penguin") {
    static output_obj = buffer_create(1024, buffer_grow, 1);
    static output_mtl = buffer_create(1024, buffer_grow, 1);
    
    base_filename = filename_change_ext(base_filename, "");
    
    var path = filename_path(base_filename);
    
    buffer_seek(output_obj, buffer_seek_start, 0);
    buffer_seek(output_mtl, buffer_seek_start, 0);
    
    buffer_write(output_obj, buffer_text, "# " + title + "\r\n\r\n");
    buffer_write(output_obj, buffer_text, "mtllib " + filename_name(base_filename) + ".mtl\r\n\r\n");
    
    buffer_write(output_mtl, buffer_text, "# " + title + "\r\n");
    buffer_write(output_mtl, buffer_text, "# Material count: " + string(array_length(mesh.submeshes)) + "\r\n\r\n");
    
    // because you're allowed to give multiple submeshes the same name if you really want to
    var material_names_cache = { };
    static get_available_material_name = function(cache, name) {
        var test_name = name;
        var i = 1;
        while (variable_struct_exists(cache, test_name)) {
            test_name = name + "_" + string(i++);
        }
        cache[$ test_name] = true;
        return test_name;
    };
    
    #region write the material data
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        var cr = colour_get_red(submesh.col_diffuse) / 0xff;
        var cg = colour_get_green(submesh.col_diffuse) / 0xff;
        var cb = colour_get_blue(submesh.col_diffuse) / 0xff;
        var ca = submesh.alpha;
        
        var material_name = get_available_material_name(material_names_cache, submesh.name);
        
        buffer_write(output_mtl, buffer_text, "newmtl " + material_name + "\r\n");
        buffer_write(output_mtl, buffer_text, "Kd " + string(cr) + " " + string(cg) + " " + string(cb) + "\r\n");
        buffer_write(output_mtl, buffer_text, "d " + string(ca) + "\r\n");
        
        // there are a lot of texture maps that may or may not need to be used
        if (submesh.tex_base != NULL) buffer_write(output_mtl, buffer_text, "map_Kd " + string_filename(guid_get(submesh.tex_base).name) + ".png\r\n");
        if (submesh.tex_ambient != NULL) buffer_write(output_mtl, buffer_text, "map_Ka " + string_filename(guid_get(submesh.tex_ambient).name) + ".png\r\n");
        if (submesh.tex_specular_color != NULL) buffer_write(output_mtl, buffer_text, "map_Ks " + string_filename(guid_get(submesh.tex_specular_color).name) + ".png\r\n");
        if (submesh.tex_specular_highlight != NULL) buffer_write(output_mtl, buffer_text, "map_Ns " + string_filename(guid_get(submesh.tex_specular_highlight).name) + ".png\r\n");
        if (submesh.tex_alpha != NULL) buffer_write(output_mtl, buffer_text, "map_d " + string_filename(guid_get(submesh.tex_alpha).name) + ".png\r\n");
        if (submesh.tex_bump != NULL) buffer_write(output_mtl, buffer_text, "map_bump " + string_filename(guid_get(submesh.tex_bump).name) + ".png\r\n");
        if (submesh.tex_displacement != NULL) buffer_write(output_mtl, buffer_text, "map_disp " + string_filename(guid_get(submesh.tex_displacement).name) + ".png\r\n");
        if (submesh.tex_stencil != NULL) buffer_write(output_mtl, buffer_text, "map_decal " + string_filename(guid_get(submesh.tex_stencil).name) + ".png\r\n");
        
        if (submesh.tex_base != NULL) guid_get(submesh.tex_base).SaveToFile(path + string_filename(guid_get(mesh.tex_base).name) + ".png");
        if (submesh.tex_ambient != NULL) guid_get(submesh.tex_ambient).SaveToFile(path + string_filename(guid_get(mesh.tex_ambient).name) + ".png");
        if (submesh.tex_specular_color != NULL) guid_get(submesh.tex_specular_color).SaveToFile(path + string_filename(guid_get(mesh.tex_specular_color).name) + ".png");
        if (submesh.tex_specular_highlight != NULL) guid_get(submesh.tex_specular_highlight).SaveToFile(path + string_filename(guid_get(mesh.tex_specular_highlight).name) + ".png");
        if (submesh.tex_alpha != NULL) guid_get(submesh.tex_alpha).SaveToFile(path + string_filename(guid_get(mesh.tex_alpha).name) + ".png");
        if (submesh.tex_bump != NULL) guid_get(submesh.tex_bump).SaveToFile(path + string_filename(guid_get(mesh.tex_bump).name) + ".png");
        if (submesh.tex_displacement != NULL) guid_get(submesh.tex_displacement).SaveToFile(path + string_filename(guid_get(mesh.tex_displacement).name) + ".png");
        if (submesh.tex_stencil != NULL) guid_get(submesh.tex_stencil).SaveToFile(path + string_filename(guid_get(mesh.tex_stencil).name) + ".png");
    }
    #endregion
    
    var material_names_cache = { };
    
    var face_index = 1;
    
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        var material_name = get_available_material_name(material_names_cache, submesh.name);
        buffer_write(output_obj, buffer_text, "usemtl " + filename_name(material_name) + "\r\n");
        buffer_write(output_obj, buffer_text, "g " + filename_name(material_name) + "\r\n");
        
        buffer_seek(submesh.buffer, buffer_seek_start, 0);
        
        for (var j = 0, n = buffer_get_size(submesh.buffer); j < n; j += VERTEX_SIZE * 3) {
            for (var k = 0; k < 3; k++) {
                var xx =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 00, buffer_f32);
                var yy =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 04, buffer_f32);
                var zz =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 08, buffer_f32);
                var nx =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 12, buffer_f32);
                var ny =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 16, buffer_f32);
                var nz =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 20, buffer_f32);
                var xt =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 24, buffer_f32);
                var yt =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 28, buffer_f32);
                var cc =    buffer_peek(submesh.buffer, j + k * VERTEX_SIZE + 32, buffer_u32);
                
                buffer_write(output_obj, buffer_text, "v " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) + "\r\n");
                buffer_write(output_obj, buffer_text, "vt " + decimal(xt) + " " + decimal(yt) + "\r\n");
                buffer_write(output_obj, buffer_text, "vn " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + "\r\n");
            }
            
            var text1 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            var text2 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            var text3 = string(face_index) + "/" + string(face_index) + "/" + string(face_index);
            face_index++;
            buffer_write(output_obj, buffer_text, "f " + text1 + " " + text2 + " " + text3 + "\r\n\r\n");
        }
    }
    
    buffer_save_ext(output_obj, base_filename + ".obj", 0, buffer_tell(output_obj));
    buffer_save_ext(output_mtl, base_filename + ".mtl", 0, buffer_tell(output_mtl));
}