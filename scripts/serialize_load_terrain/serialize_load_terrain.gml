/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var terrain = Stuff.terrain;

buffer_read(buffer, buffer_u32);

var n_terrain = buffer_read(buffer, buffer_u16);

repeat (n_terrain) {
    terrain.height = buffer_read(buffer, buffer_u16);
    terrain.width = buffer_read(buffer, buffer_u16);
    
    var bools = buffer_read(buffer, buffer_u32);
    terrain.view_cylinder = unpack(bools, 0);
    terrain.export_all = unpack(bools, 0);
    terrain.view_water = unpack(bools, 0);
    terrain.export_swap_uvs = unpack(bools, 0);
    terrain.export_swap_zup = unpack(bools, 0);
    
    terrain.view_scale = buffer_read(buffer, buffer_f32);
    terrain.save_scale = buffer_read(buffer, buffer_f32);
    
    terrain.rate = buffer_read(buffer, buffer_f32);
    terrain.radius = buffer_read(buffer, buffer_f32);
    terrain.mode = buffer_read(buffer, buffer_u8);
    terrain.submode = buffer_read(buffer, buffer_u8);
    terrain.style = buffer_read(buffer, buffer_u8);
    
    terrain.tile_brush_x = buffer_read(buffer, buffer_f32);
    terrain.tile_brush_y = buffer_read(buffer, buffer_f32);
    terrain.paint_color = buffer_read(buffer, buffer_u32);
    terrain.paint_strength = buffer_read(buffer, buffer_u8);
    terrain.paint_precision = buffer_read(buffer, buffer_u8);
    
    buffer_delete(terrain.height_data);
    buffer_delete(terrain.color_data);
    
    var height_length = buffer_read(buffer, buffer_u32);
    var color_length = buffer_read(buffer, buffer_u32);
    terrain.height_data = buffer_read_buffer(buffer, height_length);
    terrain.color_data = buffer_read_buffer(buffer, color_length);
    
    vertex_delete_buffer(terrain.terrain_buffer);
    buffer_delete(terrain.terrain_buffer_data);
    
    terrain.terrain_buffer = vertex_create_buffer();
    vertex_begin(terrain.terrain_buffer, terrain.vertex_format);
    
    for (var i = 0; i < terrain.width - 1; i++) {
        for (var j = 0; j < terrain.height - 1; j++) {
            var z0 = terrain_get_z(terrain, i, j);
            var z1 = terrain_get_z(terrain, i + 1, j);
            var z2 = terrain_get_z(terrain, i + 1, j + 1);
            var z3 = terrain_get_z(terrain, i, j + 1);
            var c0 = terrain_get_color(terrain, i, j);
            var c1 = terrain_get_color(terrain, i + 1, j);
            var c2 = terrain_get_color(terrain, i + 1, j + 1);
            var c3 = terrain_get_color(terrain, i, j + 1);
            terrain_create_square(terrain.terrain_buffer, i, j, 1, 0, 0, terrain.tile_size, terrain.texel, z0, z1, z2, z3, c0, c1, c2, c3);
        }
    }
    
    vertex_end(terrain.terrain_buffer);
    terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);
    vertex_freeze(terrain.terrain_buffer);
}