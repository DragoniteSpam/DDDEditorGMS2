/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var terrain = Stuff.terrain;

buffer_read(buffer, buffer_u32);

var n_terrain = buffer_read(buffer, buffer_u16);

repeat (n_terrain) {
    terrain.height = buffer_read(buffer, buffer_u16);
    Camera.Stuff.terrain.ui.t_general.element_height.text = "Height: " + string(terrain.height);
    terrain.width = buffer_read(buffer, buffer_u16);
    Camera.Stuff.terrain.ui.t_general.element_width.text = "Width: " + string(terrain.width);
    
    var bools = buffer_read(buffer, buffer_u32);
    terrain.export_all = unpack(bools, 1);
    Camera.Stuff.terrain.ui.t_general.element_save_all_faces.value = terrain.export_all;
    terrain.export_swap_uvs = unpack(bools, 3);
    Camera.Stuff.terrain.ui.t_general.element_swap_uvs.value = terrain.export_swap_uvs;
    terrain.export_swap_zup = unpack(bools, 4);
    Camera.Stuff.terrain.ui.t_general.element_swap_zup.value = terrain.export_swap_zup;
    terrain.smooth_shading = unpack(bools, 5);
    Camera.Stuff.terrain.ui.t_general.element_smooth_shading.value = terrain.smooth_shading;
    terrain.dual_layer  = unpack(bools, 6);
    Camera.Stuff.terrain.ui.t_general.element_dual.value = terrain.dual_layer;
    
    terrain.view_scale = buffer_read(buffer, buffer_f32);
    // not available as a value you can change currently
    terrain.save_scale = buffer_read(buffer, buffer_f32);
    Camera.Stuff.terrain.ui.t_general.element_save_scale.value = string(terrain.save_scale);
    
    // all of these aren't actually loaded anymore, because it turns out that I'd prefer they reset
    buffer_read(buffer, buffer_f32);
    buffer_read(buffer, buffer_f32);
    buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_u8);
    
    buffer_read(buffer, buffer_f32);
    buffer_read(buffer, buffer_f32);
    
    buffer_read(buffer, buffer_u32);
    buffer_read(buffer, buffer_f32);
    buffer_read(buffer, buffer_u8);
    
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