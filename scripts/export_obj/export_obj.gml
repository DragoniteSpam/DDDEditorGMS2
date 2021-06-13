/// @param fname
/// @param DataMesh
/// @param [scale-texture?]
function export_obj() {

    var base_filename = argument[0];
    var path = filename_path(base_filename);
    var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
    var mesh = argument[1];
    var scale = (argument_count > 2 && argument[2] != undefined) ? argument[2] : true;
    var buffer = buffer_create(1024, buffer_grow, 1);

    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var number_ext = (array_length(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var sub = mesh.submeshes[i];
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        buffer_seek(sub.buffer, buffer_seek_start, 0);
        buffer_seek(buffer, buffer_seek_start, 0);
    
        buffer_write(buffer, buffer_text, "# DDD\r\n");
        buffer_write(buffer, buffer_text, "mtllib " + filename_name(filename_name(filename_change_ext(fn, ".mtl"))) + "\r\n\r\n");
    
        var active_mtl = "None";
    
        var mtl_alpha = ds_map_create();
        var mtl_r = ds_map_create();
        var mtl_g = ds_map_create();
        var mtl_b = ds_map_create();
    
        var color = [0xffffffff, 0xffffffff, 0xffffffff];
        var xx, yy, zz, nx, ny, nz, xtex, ytex;
    
        var n = 1;
        
        while (buffer_tell(sub.buffer) < buffer_get_size(sub.buffer)) {
            for (var j = 0; j < 3; j++) {
                xx = buffer_read(sub.buffer, buffer_f32);
                yy = buffer_read(sub.buffer, buffer_f32);
                zz = buffer_read(sub.buffer, buffer_f32);
                nx = buffer_read(sub.buffer, buffer_f32);
                ny = buffer_read(sub.buffer, buffer_f32);
                nz = buffer_read(sub.buffer, buffer_f32);
                xtex = buffer_read(sub.buffer, buffer_f32);
                ytex = buffer_read(sub.buffer, buffer_f32);
                color[j] = buffer_read(sub.buffer, buffer_u32);
            
                buffer_write(buffer, buffer_text, "v " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) + "\r\n");
                buffer_write(buffer, buffer_text, "vt " + decimal(xtex) + " " + decimal(ytex) + "\r\n");
                buffer_write(buffer, buffer_text, "vn " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + "\r\n");
            }
    
            var c = floor(((color[0] & 0xffffff) + (color[1] & 0xffffff) + (color[2] & 0xffffff)) / 3);
            var a = (((color[0] & 0xff000000) >> 24) + ((color[1] & 0xff000000) >> 24) + ((color[2] & 0xff000000) >> 24)) / 3;
        
            // this may need updating if materials are dealt with properly later
            var mtl_name = string(floor((color[0] + color[1] + color[2]) / 4));
    
            if (!ds_map_exists(mtl_alpha, mtl_name)) {
                mtl_alpha[? mtl_name] = a / 255;
                mtl_r[? mtl_name] = (c & 0x0000ff) / 255;
                mtl_g[? mtl_name] = ((c & 0x00ff00) >> 8) / 255;
                mtl_b[? mtl_name] = ((c & 0xff0000) >> 16) / 255;
            }
    
            active_mtl = mtl_name;
    
            if (string_length(active_mtl) > 0) {
                buffer_write(buffer, buffer_text, "usemtl " + active_mtl + "\r\n");
            }
        
            var text0 = string(n) + "/" + string(n) + "/" + string(n);
            n++;
            var text1 = string(n) + "/" + string(n) + "/" + string(n);
            n++;
            var text2 = string(n) + "/" + string(n) + "/" + string(n);
            n++;
            buffer_write(buffer, buffer_text, "f " + text0 + " " + text1 + " " + text2 + "\r\n\r\n");
        }

        buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
        buffer_seek(buffer, buffer_seek_start, 0);

        buffer_write(buffer, buffer_text, "# DDD MTL file\r\n");
        buffer_write(buffer, buffer_text, "# Material count: " + string(ds_map_size(mtl_alpha)) + "\r\n");

        for (var mtl = ds_map_find_first(mtl_alpha); mtl != undefined; mtl = ds_map_find_next(mtl_alpha, mtl)) {
            buffer_write(buffer, buffer_text, "\r\nnewmtl " + mtl + "\r\n");
            buffer_write(buffer, buffer_text, "Kd " + string(mtl_r[? mtl]) + " " + string(mtl_g[? mtl]) + " " + string(mtl_b[? mtl]) + "\r\n");
            buffer_write(buffer, buffer_text, "d " + string(mtl_alpha[? mtl]) + "\r\n");
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
    
        ds_map_destroy(mtl_alpha);
        ds_map_destroy(mtl_r);
        ds_map_destroy(mtl_g);
        ds_map_destroy(mtl_b);
    }

    buffer_delete(buffer);


}
