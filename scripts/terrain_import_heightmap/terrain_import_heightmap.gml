function terrain_import_heightmap(button, fn) {
    var image = sprite_add(fn, 0, false, false, 0, 0);
    var terrain = Stuff.terrain;
    var dual = button.root.el_dual_layer.value;
    var scale = string(button.root.el_scale.value);
    
    terrain.dual_layer = dual;
    terrain.width = sprite_get_width(image);
    terrain.height = sprite_get_height(image);
    
    var buffer = sprite_to_buffer(image, 0);
    
    buffer_delete(terrain.height_data);
    buffer_delete(terrain.terrain_buffer_data);
    vertex_delete_buffer(terrain.terrain_buffer);
    
    terrain.color.Reset();
    terrain.height_data = terrainops_from_heightmap(buffer, scale);
    terrain.terrain_buffer_data = terrainops_generate(terrain.height_data, terrain.width, terrain.height);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    
    buffer_delete(buffer);
    sprite_delete(image);
}