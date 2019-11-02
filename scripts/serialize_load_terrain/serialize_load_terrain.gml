/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var terrain = Stuff.terrain;

buffer_read(buffer, buffer_u32);

var n_terrain = buffer_read(buffer, buffer_u16);

repeat (n_terrain) {
    terrain.height = buffer_read(buffer, buffer_u16);
    Camera.ui_terrain.t_general.element_height.text = "Height: " + string(terrain.height);
    terrain.width = buffer_read(buffer, buffer_u16);
    Camera.ui_terrain.t_general.element_width.text = "Width: " + string(terrain.width);
    
    var bools = buffer_read(buffer, buffer_u32);
    terrain.view_cylinder = unpack(bools, 0);
    Camera.ui_terrain.t_general.element_draw_cylinder.value = terrain.view_cylinder;
    terrain.export_all = unpack(bools, 1);
    Camera.ui_terrain.t_general.element_save_all_faces.value = terrain.export_all;
    terrain.view_water = unpack(bools, 2);
    Camera.ui_terrain.t_general.element_draw_water.value = terrain.view_water;
    terrain.export_swap_uvs = unpack(bools, 3);
    Camera.ui_terrain.t_general.element_swap_uvs.value = terrain.export_swap_uvs;
    terrain.export_swap_zup = unpack(bools, 4);
    Camera.ui_terrain.t_general.element_swap_zup.value = terrain.export_swap_zup;
    terrain.smooth_shading = unpack(bools, 5);
    Camera.ui_terrain.t_general.element_smooth_shading.value = terrain.smooth_shading;
    
    terrain.view_scale = buffer_read(buffer, buffer_f32);
    // not available as a value you can change currently
    terrain.save_scale = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_general.element_save_scale.value = string(terrain.save_scale);
    
    terrain.rate = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_heightmap.element_deform_rate.value = string(terrain.rate);
    Camera.ui_terrain.t_heightmap.element_deform_rate.value = normalize(terrain.rate, 0, 1, terrain.rate_min, terrain.rate_max);
    terrain.radius = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_general.element_brush_radius.value = string(terrain.radius);
    Camera.ui_terrain.t_general.element_brush_radius_bar.value = normalize(terrain.radius, 0, 1, terrain.brush_min, terrain.brush_max);
    terrain.mode = buffer_read(buffer, buffer_u8);
    Camera.ui_terrain.t_general.element_mode.value = terrain.mode;
    terrain.submode = buffer_read(buffer, buffer_u8);
    Camera.ui_terrain.t_heightmap.element_deform_mode.value = terrain.submode;
    terrain.style = buffer_read(buffer, buffer_u8);
    Camera.ui_terrain.t_general.element_brush_shape.value = terrain.style;
    
    terrain.tile_brush_x = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_texture.element_tile_selector.tile_x = terrain.tile_brush_x;
    terrain.tile_brush_y = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_texture.element_tile_selector.tile_y = terrain.tile_brush_y;
    
    terrain.paint_color = buffer_read(buffer, buffer_u32);
    Camera.ui_terrain.t_paint.element_paint_color.value = terrain.paint_color;
    terrain.paint_strength = buffer_read(buffer, buffer_f32);
    Camera.ui_terrain.t_paint.element_paint_strength.value = string(terrain.paint_strength);
    Camera.ui_terrain.t_paint.element_paint_strength_bar.value = normalize(terrain.paint_strength, 0, 1, terrain.paint_strength_min, terrain.paint_strength_max);
    terrain.paint_precision = buffer_read(buffer, buffer_u8);
    Camera.ui_terrain.t_paint.element_paint_precision.value = string(terrain.paint_precision);
    Camera.ui_terrain.t_paint.element_paint_precision_bar.value = normalize(terrain.paint_precision, 0, 1, terrain.paint_precision_min, terrain.paint_precision_max);
    
    buffer_delete(terrain.height_data);
    buffer_delete(terrain.color_data);
    buffer_delete(terrain.terrain_buffer_data);
    
    var height_length = buffer_read(buffer, buffer_u32);
    var color_length = buffer_read(buffer, buffer_u32);
    var data_length = buffer_read(buffer, buffer_u32);
    terrain.height_data = buffer_read_buffer(buffer, height_length);
    terrain.color_data = buffer_read_buffer(buffer, color_length);
    terrain.terrain_buffer_data = buffer_read_buffer(buffer, data_length);
    
    terrain_refresh_vertex_buffer(terrain);
}