function terrain_set_texture(terrain, x, y, xtex, ytex) {
    var xtex2 = xtex + terrain.tile_size;
    var ytex2 = ytex + terrain.tile_size;
    
    if (x > 0 && y > 0) {
        var index0 = terrain_get_vertex_index(terrain, x - 1, y - 1, 0);
        var index1 = index0 + VERTEX_SIZE;
        var index2 = index1 + VERTEX_SIZE;
        var index3 = index2 + VERTEX_SIZE;
        var index4 = index3 + VERTEX_SIZE;
        var index5 = index4 + VERTEX_SIZE;
        
        buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, ytex);
    }
    
    if (x < terrain.width && y > 0) {
        var index3 = terrain_get_vertex_index(terrain, x - 1, y - 1, 3);
        var index4 = index3 + VERTEX_SIZE;
        var index5 = index4 + VERTEX_SIZE;
        
        buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, ytex);
    }
    
    if (x > 0 && y < terrain.height) {
        var index0 = terrain_get_vertex_index(terrain, x - 1, y - 1, 0);
        var index1 = index0 + VERTEX_SIZE;
        var index2 = index1 + VERTEX_SIZE;
        
        buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, ytex2);
    }
    
    if (x < terrain.width && y < terrain.height) {
        var index0 = terrain_get_vertex_index(terrain, x - 1, y - 1, 0);
        var index1 = index0 + VERTEX_SIZE;
        var index2 = index1 + VERTEX_SIZE;
        var index3 = index2 + VERTEX_SIZE;
        var index4 = index3 + VERTEX_SIZE;
        var index5 = index4 + VERTEX_SIZE;
        
        buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, ytex);
        buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, xtex2);
        buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, ytex2);
        buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, xtex);
        buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, ytex);
    }
}