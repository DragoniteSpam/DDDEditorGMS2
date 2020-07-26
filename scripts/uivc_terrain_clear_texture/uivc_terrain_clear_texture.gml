/// @param UIButton

var button = argument0;
var terrain = Stuff.terrain;

for (var i = 0; i < terrain.width - 1; i++) {
    for (var j = 0; j < terrain.height - 1; j++) {
        var index0 = terrain_get_vertex_index(terrain, i, j, 0);
        var index1 = index0 + VERTEX_SIZE_BASIC;
        var index2 = index1 + VERTEX_SIZE_BASIC;
        var index3 = index2 + VERTEX_SIZE_BASIC;
        var index4 = index3 + VERTEX_SIZE_BASIC;
        var index5 = index4 + VERTEX_SIZE_BASIC;
        
        buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, terrain.tile_brush_x + terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, terrain.tile_brush_x + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, terrain.tile_brush_x + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, terrain.tile_brush_x + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, terrain.tile_brush_x + terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, terrain.tile_brush_x + terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, terrain.tile_brush_y + terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, terrain.tile_brush_y + terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, terrain.tile_brush_y + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, terrain.tile_brush_y + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, terrain.tile_brush_y + terrain.tile_size - terrain.texel);
        buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, terrain.tile_brush_y + terrain.texel);
    }
}

terrain_refresh_vertex_buffer(terrain);