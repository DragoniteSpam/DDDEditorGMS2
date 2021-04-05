function uivc_terrain_reset_z(button) {
    var terrain = Stuff.terrain;
    buffer_fill(terrain.height_data, 0, buffer_f32, 0, buffer_get_size(terrain.height_data));
    
    for (var i = 0; i < terrain.width - 1; i++) {
        for (var j = 0; j < terrain.height - 1; j++) {
            var index0 = terrain_get_vertex_index(terrain, i, j, 0);
            var index1 = index0 + VERTEX_SIZE;
            var index2 = index1 + VERTEX_SIZE;
            var index3 = index2 + VERTEX_SIZE;
            var index4 = index3 + VERTEX_SIZE;
            var index5 = index4 + VERTEX_SIZE;
            
            buffer_poke(terrain.terrain_buffer_data, index0 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index1 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index2 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index3 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index4 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index5 + 8, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index0 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index1 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index2 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index3 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index4 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index5 + 12, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index0 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index1 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index2 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index3 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index4 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index5 + 16, buffer_f32, 0);
            buffer_poke(terrain.terrain_buffer_data, index0 + 20, buffer_f32, 1);
            buffer_poke(terrain.terrain_buffer_data, index1 + 20, buffer_f32, 1);
            buffer_poke(terrain.terrain_buffer_data, index2 + 20, buffer_f32, 1);
            buffer_poke(terrain.terrain_buffer_data, index3 + 20, buffer_f32, 1);
            buffer_poke(terrain.terrain_buffer_data, index4 + 20, buffer_f32, 1);
            buffer_poke(terrain.terrain_buffer_data, index5 + 20, buffer_f32, 1);
        }
    }
    
    terrain_refresh_vertex_buffer(terrain);
}