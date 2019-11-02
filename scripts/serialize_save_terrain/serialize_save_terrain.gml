/// @param buffer

var buffer = argument0;
var terrain = Stuff.terrain;

buffer_write(buffer, buffer_datatype, SerializeThings.TERRAIN_HEIGHTMAP);

// in the event that i set this up so it can have more than one terrain - although i probably
// won't because they're fairly memory-intensive
buffer_write(buffer, buffer_u16, 1);

buffer_write(buffer, buffer_u16, terrain.height);
buffer_write(buffer, buffer_u16, terrain.width);

// i'm also going to save the settings, just in case

var bools = pack(terrain.view_cylinder, terrain.export_all, terrain.view_water, terrain.export_swap_uvs, terrain.export_swap_zup);
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
buffer_write(buffer, buffer_u8, terrain.paint_strength);
buffer_write(buffer, buffer_u8, terrain.paint_precision);

// the actual data

buffer_write_buffer(buffer, terrain.height_data);
buffer_write_buffer(buffer, terrain.color_data);