#macro terrain_texture_size                                                     sprite_get_height(Stuff.terrain.texture)
#macro terrain_tile_size                                                        (32 / terrain_texture_size)

function terrain_get_z(terrain, xx, yy) {
    return buffer_peek(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32);
}

function terrain_add_z(terrain, xx, yy, value) {
    terrain_set_z(terrain, xx, yy, terrain_get_z(terrain, xx, yy) + value);
}

function terrain_get_data_index(terrain, xx, yy) {
    return (xx * (terrain.height + 1) + yy) * 4;
}

function terrain_get_vertex_index(terrain, x, y, vertex) {
    // the -1 is annoying and unfortunately comes up a lot. the vertex buffer
    // would is actually one shorter in each dimension than the width and height,
    // because of the way the squares are arranged.
    return VERTEX_SIZE_TERRAIN * ((x * terrain.height + y) * terrain.vertices_per_square + vertex);
}

function terrain_refresh_vertex_buffer(terrain) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    vertex_freeze(terrain.terrain_buffer);
}

function terrain_create_square(buffer, xx, yy, z00, z10, z11, z01) {
    vertex_position_3d(buffer, xx, yy, z00);
    vertex_position_3d(buffer, xx + 1, yy, z10);
    vertex_position_3d(buffer, xx + 1, yy + 1, z11);
    vertex_position_3d(buffer, xx + 1, yy + 1, z11);
    vertex_position_3d(buffer, xx, yy + 1, z01);
    vertex_position_3d(buffer, xx, yy, z00);
}