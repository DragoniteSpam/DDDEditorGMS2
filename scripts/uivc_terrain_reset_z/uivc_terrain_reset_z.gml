/// @param UIButton

var button = argument0;
var terrain = Stuff.terrain;

buffer_fill(terrain.height_data, 0, buffer_f32, 0, buffer_get_size(terrain.height_data));

for (var i = 0; i < terrain.width - 1; i++) {
    for (var j = 0; j < terrain.height - 1; j++) {
        var index0 = terrain_get_vertex_index(terrain, i, i, 0);
        var index1 = index0 + terrain.format_size;
        var index2 = index1 + terrain.format_size;
        var index3 = index2 + terrain.format_size;
        var index4 = index3 + terrain.format_size;
        var index5 = index4 + terrain.format_size;
        
        buffer_poke(terrain.terrain_buffer_data, index0 + 8, buffer_f32, 0);
        buffer_poke(terrain.terrain_buffer_data, index1 + 8, buffer_f32, 0);
        buffer_poke(terrain.terrain_buffer_data, index2 + 8, buffer_f32, 0);
        buffer_poke(terrain.terrain_buffer_data, index3 + 8, buffer_f32, 0);
        buffer_poke(terrain.terrain_buffer_data, index4 + 8, buffer_f32, 0);
        buffer_poke(terrain.terrain_buffer_data, index5 + 8, buffer_f32, 0);
    }
}