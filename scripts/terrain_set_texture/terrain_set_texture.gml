/// @param terrain
/// @param x
/// @param y
/// @param xtex
/// @param ytex

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var xtex = argument3;
var ytex = argument4;
var xtex2 = xtex + terrain.tile_size;
var ytex2 = ytex + terrain.tile_size;

if (xx > 0 && yy > 0) {
    var index0 = terrain_get_vertex_index(terrain, xx - 1, yy - 1, 0);
    var index1 = index0 + Stuff.graphics.format_size_basic;
    var index2 = index1 + Stuff.graphics.format_size_basic;
    var index3 = index2 + Stuff.graphics.format_size_basic;
    var index4 = index3 + Stuff.graphics.format_size_basic;
    var index5 = index4 + Stuff.graphics.format_size_basic;
    
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

if (xx < terrain.width && yy > 0) {
    var index3 = terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3);
    var index4 = index3 + Stuff.graphics.format_size_basic;
    var index5 = index4 + Stuff.graphics.format_size_basic;
    
    buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, xtex2);
    buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, ytex2);
    buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, xtex);
    buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, ytex2);
    buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, xtex);
    buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, ytex);
}

if (xx > 0 && yy < terrain.height) {
    var index0 = terrain_get_vertex_index(terrain, xx - 1, yy - 1, 0);
    var index1 = index0 + Stuff.graphics.format_size_basic;
    var index2 = index1 + Stuff.graphics.format_size_basic;
    
    buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, xtex);
    buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, ytex);
    buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, xtex2);
    buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, ytex);
    buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, xtex2);
    buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, ytex2);
}

if (xx < terrain.width && yy < terrain.height) {
    var index0 = terrain_get_vertex_index(terrain, xx - 1, yy - 1, 0);
    var index1 = index0 + Stuff.graphics.format_size_basic;
    var index2 = index1 + Stuff.graphics.format_size_basic;
    var index3 = index2 + Stuff.graphics.format_size_basic;
    var index4 = index3 + Stuff.graphics.format_size_basic;
    var index5 = index4 + Stuff.graphics.format_size_basic;
    
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