function terrain_set_z(terrain, x, y, value) {
    buffer_poke(terrain.height_data, terrain_get_data_index(terrain, x, y), buffer_f32, value);
    
    if (x > 0 && y > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y - 1, 2) + 8, buffer_f32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y - 1, 3) + 8, buffer_f32, value);
    }
    
    if (x < terrain.width && y > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y - 1, 4) + 8, buffer_f32, value);
    }
    
    if (x > 0 && y < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y, 1) + 8, buffer_f32, value);
    }
    
    if (x < terrain.width && y < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y, 0) + 8, buffer_f32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y, 5) + 8, buffer_f32, value);
    }
}