#macro terrain_texture_size                                                     sprite_get_height(Stuff.terrain.texture)
#macro terrain_tile_size                                                        (32 / terrain_texture_size)

function terrain_get_z(terrain, xx, yy) {
    return buffer_peek(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32);
}

function terrain_add_z(terrain, xx, yy, value) {
    terrain_set_z(terrain, xx, yy, terrain_get_z(terrain, xx, yy) + value);
}

function terrain_get_data_index(terrain, xx, yy) {
    return (xx * terrain.height + yy) * 4;
}

function terrain_get_vertex_index(terrain, x, y, vertex) {
    // the -1 is annoying and unfortunately comes up a lot. the vertex buffer
    // would is actually one shorter in each dimension than the width and height,
    // because of the way the squares are arranged.
    return VERTEX_SIZE_TERRAIN * ((x * (terrain.height - 1) + y) * 6 + vertex);
}

function terrain_refresh_vertex_buffer(terrain) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    vertex_freeze(terrain.terrain_buffer);
}

function terrain_set_z(terrain, x, y, value) {
    buffer_poke(terrain.height_data, terrain_get_data_index(terrain, x, y), buffer_f32, value);
    
    if (x > 0 && y > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y - 1, 2) + 8, buffer_f32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y - 1, 3) + 8, buffer_f32, value);
    }
    
    if (x < terrain.width && y > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y - 1, 4) + 8, buffer_f32, value);
    }
    
    if (x > 0 && y < terrain.height - 1) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x - 1, y, 1) + 8, buffer_f32, value);
    }
    
    if (x < terrain.width && y < terrain.height - 1) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y, 0) + 8, buffer_f32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, x, y, 5) + 8, buffer_f32, value);
    }
}

function terrain_set_texture(terrain, x, y, xtex, ytex) {
    var xtex2 = xtex + terrain_tile_size;
    var ytex2 = ytex + terrain_tile_size;
    
    wtf("terrain_set_texture - use the black magic of texture samplers for this");
}