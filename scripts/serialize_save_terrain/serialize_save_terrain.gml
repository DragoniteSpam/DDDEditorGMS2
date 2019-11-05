/// @param buffer

var buffer = argument0;
var terrain = Stuff.terrain;

buffer_write(buffer, buffer_datatype, SerializeThings.TERRAIN_HEIGHTMAP);

var addr_end = buffer_tell(buffer);
buffer_write(buffer, buffer_u32, 0);

// in the event that i set this up so it can have more than one terrain - although i probably
// won't because they're fairly memory-intensive
buffer_write(buffer, buffer_u16, 1);

buffer_write(buffer, buffer_u16, terrain.height);
buffer_write(buffer, buffer_u16, terrain.width);

// i'm also going to save the settings, just in case - i decided not to read most of
// them back out but still
var bools = pack(0, terrain.export_all, terrain.view_water, terrain.export_swap_uvs, terrain.export_swap_zup, terrain.smooth_shading, terrain.dual_layer);
buffer_write(buffer, buffer_u32, bools);
buffer_write(buffer, buffer_f32, terrain.view_scale);
buffer_write(buffer, buffer_f32, terrain.save_scale);

buffer_write(buffer, buffer_f32, terrain.rate);
buffer_write(buffer, buffer_f32, terrain.radius);
buffer_write(buffer, buffer_u8, terrain.mode);
buffer_write(buffer, buffer_u8, terrain.submode);
buffer_write(buffer, buffer_u8, terrain.style);

buffer_write(buffer, buffer_f32, terrain.tile_brush_x);
buffer_write(buffer, buffer_f32, terrain.tile_brush_y);
buffer_write(buffer, buffer_u32, terrain.paint_color);
buffer_write(buffer, buffer_f32, terrain.paint_strength);
buffer_write(buffer, buffer_u8, terrain.paint_precision);

// the actual data

buffer_write(buffer, buffer_u32, buffer_get_size(terrain.height_data));
buffer_write(buffer, buffer_u32, buffer_get_size(terrain.color_data));
buffer_write(buffer, buffer_u32, buffer_get_size(terrain.terrain_buffer_data));
buffer_write_buffer(buffer, terrain.height_data);
buffer_write_buffer(buffer, terrain.color_data);
buffer_write_buffer(buffer, terrain.terrain_buffer_data);

buffer_poke(buffer, addr_end, buffer_u32, buffer_tell(buffer));