function terrain_refresh_vertex_buffer(terrain) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    vertex_freeze(terrain.terrain_buffer);
}