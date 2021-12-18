function terrain_save_d3d(fn) {
    var terrain = Stuff.terrain;
    var bytes = buffer_get_size(terrain.terrain_buffer_data);
    var vertices = 0;
    var scale = terrain.save_scale;
    
    var fx = sprite_get_width(terrain.texture) / terrain_texture_size;
    var fy = sprite_get_height(terrain.texture) / terrain_texture_size;
    
    // I guess you can implement uv and zup flipping here as well, but game maker models don't
    // typically use a different up vector or texture coordinate system
    
    // because regular string() doesn't give you very good precision
    var mediump = 3;
    var highp = 8;
    
    var buffer = buffer_create(1000000, buffer_grow, 1);
    buffer_write(buffer, buffer_text, "100\n");
    var addr_capacity = buffer_tell(buffer);
    buffer_write(buffer, buffer_text, "00000000\n0 4\n");
    
    throw "terrain_save_d3d - sample from the various textures instead of from a big-ass vertex buffer";
    
    for (var i = 0; i < bytes; i += VERTEX_SIZE_TERRAIN * 3) {
        var z0 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_TERRAIN * 0, buffer_f32) * scale;
        var z1 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_TERRAIN * 1, buffer_f32) * scale;
        var z2 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_TERRAIN * 2, buffer_f32) * scale;
        var z3 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_TERRAIN * 3, buffer_f32) * scale;
        
        throw "re-implement this; the terrain vertex format has been gutted - see the github file history for how the options used to be implemented";
    }
    
    buffer_poke(buffer, addr_capacity, buffer_text, string_pad(vertices + 2, "0", 8));
    
    if (vertices / 3 >= 32000) {
        emu_dialog_notice("This terrain contains " + string_comma(vertices / 3) + " triangles (" + string_comma(vertices) + " total vertices). You may still use it for your own purposes, but it will not be able to view it in Model Creator, which has a limit of 32000 vertices.", 540, 240);
    }
    
    buffer_write(buffer, buffer_text, "1\n");
    
    buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
    sprite_save(terrain.texture, 0, filename_dir(fn) + "/" + terrain.texture_name);
    buffer_delete(buffer);
}