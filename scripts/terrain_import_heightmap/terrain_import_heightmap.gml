function terrain_import_heightmap(button, fn) {
    var image = sprite_add(fn, 0, false, false, 0, 0);
    var terrain = Stuff.terrain;
    var dual = button.root.el_dual_layer.value;
    var scale = string(button.root.el_scale.value);
    
    terrain.dual_layer = dual;
    terrain.width = sprite_get_width(image);
    terrain.height = sprite_get_height(image);
    
    var buffer = buffer_create(buffer_sizeof(buffer_u32) * terrain.width * terrain.height, buffer_fixed, 1);
    var surface = surface_create(terrain.width, terrain.height);
    
    surface_set_target(surface);
    draw_clear_alpha(c_white, 1);
    draw_sprite(image, 0, 0, 0);
    surface_reset_target();
    
    buffer_get_surface(buffer, surface, 0);
    
    buffer_delete(terrain.height_data);
    buffer_delete(terrain.terrain_buffer_data);
    vertex_delete_buffer(terrain.terrain_buffer);
    
    terrain.height_data = terrain.GenerateHeightData();
    terrain.color.Reset();
    
    // the first pass is reading out the data
    for (var i = 0; i < terrain.width; i++) {
        for (var j = 0; j < terrain.height; j++) {
            var color = buffer_read(buffer, buffer_u32);
            var rr = color & 0x0000ff;
            var gg = (color & 0x00ff00) >> 8;
            var bb = (color & 0xff0000) >> 16;
            var zz = mean(rr, gg, bb) / scale;
            buffer_write(terrain.height_data, buffer_f32, zz);
        }
    }
    
    terrain.terrain_buffer_data = terrainops_generate(terrain.height_data, terrain.width, terrain.height);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    
    buffer_delete(buffer);
    surface_free(surface);
    sprite_delete(image);
}