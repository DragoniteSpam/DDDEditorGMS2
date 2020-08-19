/// @param UIButton
function uivc_terrain_clear_color(argument0) {

    var button = argument0;
    var terrain = Stuff.terrain;

    buffer_fill(terrain.color_data, 0, buffer_u32, terrain.paint_color, buffer_get_size(terrain.color_data));

    for (var i = 0; i < terrain.width - 1; i++) {
        for (var j = 0; j < terrain.height - 1; j++) {
            var index0 = terrain_get_vertex_index(terrain, i, j, 0);
            var index1 = index0 + VERTEX_SIZE_BASIC;
            var index2 = index1 + VERTEX_SIZE_BASIC;
            var index3 = index2 + VERTEX_SIZE_BASIC;
            var index4 = index3 + VERTEX_SIZE_BASIC;
            var index5 = index4 + VERTEX_SIZE_BASIC;
        
            buffer_poke(terrain.terrain_buffer_data, index0 + 32, buffer_u32, terrain.paint_color);
            buffer_poke(terrain.terrain_buffer_data, index1 + 32, buffer_u32, terrain.paint_color);
            buffer_poke(terrain.terrain_buffer_data, index2 + 32, buffer_u32, terrain.paint_color);
            buffer_poke(terrain.terrain_buffer_data, index3 + 32, buffer_u32, terrain.paint_color);
            buffer_poke(terrain.terrain_buffer_data, index4 + 32, buffer_u32, terrain.paint_color);
            buffer_poke(terrain.terrain_buffer_data, index5 + 32, buffer_u32, terrain.paint_color);
        }
    }

    terrain_refresh_vertex_buffer(terrain);


}
