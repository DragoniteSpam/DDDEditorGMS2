function terrain_save_obj(fn) {
    var matfn = filename_change_ext(fn, ".mtl");
    var terrain = Stuff.terrain;
    var bytes = buffer_get_size(terrain.terrain_buffer_data);
    var vertices = 0;
    var scale = terrain.save_scale;
    
    throw "terrain_save_obj - sample from the various textures instead of from a big-ass vertex buffer";
    
    var fx = sprite_get_width(terrain.texture) / terrain_texture_width;
    var fy = sprite_get_height(terrain.texture) / terrain_texture_height;
    
    // because regular string() doesn't give you very good precision
    var mediump = 4;
    var highp = 8;
    
    var zupswap = terrain.export_swap_zup;
    var uvswap = terrain.export_swap_uvs;
    
    var active_mtl = "a-1";
    var mtl_warning = false;
    var mtl_colors = { };
    var blender_color_warning = false;
    
    var buffer = buffer_create(1000000, buffer_grow, 1);
    var buffer_mtl = buffer_create(1000, buffer_grow, 1);
    buffer_write(buffer, buffer_text, "## DDD Terrain OBJ file: " + filename_name(matfn) + "\n# Vertices: ");
    var addr_vertex_count = buffer_tell(buffer);
    buffer_write(buffer, buffer_text, "00000000\nmtllib " + filename_name(matfn) + "\n\n");
    
    buffer_write(buffer_mtl, buffer_text, "## DDD Terrain MTL file: " + filename_name(matfn) + "\n# Material count: ");
    var addr_mtl_count = buffer_tell(buffer_mtl);
    // If you exceed this you're going to have a bad time
    buffer_write(buffer_mtl, buffer_text, "00000000\n\n");
    
    buffer_write(buffer, buffer_text, "usemtl " + active_mtl + "\n");
    buffer_write(buffer_mtl, buffer_text, "newmtl " + active_mtl + "\nKd 1 1 1\nd 1\nillum 2\n\n");
    
    for (var i = 0; i < bytes; i = i + VERTEX_SIZE_TERRAIN * 3) {
        throw "re-implement this; the terrain vertex format has been gutted - see the github file history for how the options used to be implemented";
    }
    
    var warning_str = "";
    var warning_size = 0;
    
    if (mtl_warning) {
        warning_str = warning_str + "The Wavefront OBJ file format does not supprt per-vertex alpha values (only per-face) - see the Material Termplate Library specification for more information. The average alpha value will be used instead for each face.\n\n";
        warning_size = warning_size + 160;
    }
    
    if (blender_color_warning) {
        warning_str = warning_str + "This will be exported with vertex colors. Some software can import OBJ files that use vertex colors, but others (most notably, Blender) do not. You may want to check to see if the software you intend to use this with supports vertex colors.\n\n";
        warning_size = warning_size + 160;
    }
    
    if (string_length(warning_str) > 0) {
        var dialog = emu_dialog_notice(warning_str, 720, max(240, warning_size));
        dialog.el_text.alignment = fa_left;
    }
    
    buffer_poke(buffer, addr_vertex_count, buffer_text, string_pad(vertices, "0", 8));
    buffer_poke(buffer_mtl, addr_mtl_count, buffer_text, string_pad(variable_struct_names_count(mtl_colors), "0", 8));
    
    buffer_save_ext(buffer, fn, 1, buffer_tell(buffer));
    buffer_save_ext(buffer_mtl, matfn, 1, buffer_tell(buffer_mtl));
    sprite_save(terrain.texture, 0, filename_dir(fn) + "/" + terrain.texture_name);
    
    buffer_delete(buffer);
    buffer_delete(buffer_mtl);
}