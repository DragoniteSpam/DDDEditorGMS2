var terrain = Stuff.terrain;

with (instance_create_depth(0, 0, 0, UIMain)) {
    home_row_y = 32;
    
    #region setup
    t_general = create_tab("General", 0, id);
    t_heightmap = create_tab("Deform", 0, id);
    t_texture = create_tab("Texture", 0, id);
    t_paint = create_tab("Paint", 0, id);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_general, t_heightmap, t_texture, t_paint);
    
    ds_list_add(tabs, tr_general);
    
    active_tab = t_general;
    
    #endregion
    
    // don't try to make three columns. the math has been hard-coded
    // for two. everything will go very badly if you try three or more.
    var element;
    var spacing = 16;
    var legal_x = 32;
    var legal_y = home_row_y + 32;
    var legal_width = ui_legal_width();
    var col_width = legal_width / 2 - spacing * 1.5;
    var col2_x = legal_x + col_width + spacing * 2;
    
    var vx1 = col_width / 2;
    var vy1 = 0;
    var vx2 = col_width;
    var vy2 = vy1 + 24;
    
    var button_width = 128;
    
    #region tab: general
    var yy = legal_y + spacing;
    
    element = create_text(legal_x + spacing, yy, "General Settings", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Width: " + string(terrain.width), col_width, element_height, fa_left, col_width, t_general);
    t_general.element_width = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Height: " + string(terrain.height), col_width, element_height, fa_left, col_width, t_general);
    t_general.element_height = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Dual layers", col_width, element_height, null, 0, terrain.dual_layer, t_general);
    t_general.element_dual = element;
    t_general.element_dual.interactive = false;
    //ds_list_add(t_general.contents, element);
    
    //yy = yy + element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Orthographic?", col_width, element_height, ui_input_terrain_orthographic, 0, terrain.orthographic, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Draw water?", col_width, element_height, ui_input_terrain_draw_water, 0, terrain.view_water, t_general);
    t_general.element_draw_water = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Smooth shading?", col_width, element_height, ui_input_terrain_smooth_shading, 0, terrain.smooth_shading, t_general);
    t_general.element_smooth_shading = element;
    //ds_list_add(t_general.contents, element);
    
    //yy = yy + element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Editor Settings", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Mode:", col_width, element_height, ui_input_terrain_set_mode, terrain.mode, t_general);
    create_radio_array_options(element, ["Deform", "Texture", "Paint"]);
    t_general.element_mode = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Brush shape:", col_width, element_height, ui_input_terrain_set_brush_shape, terrain.style, t_general);
    create_radio_array_options(element, ["Block", "Circle"]);
    t_general.element_brush_shape = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Brush radius: " + string(terrain.radius) + " cells", col_width, element_height, fa_left, col_width, t_general);
    t_general.element_brush_radius = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_brush_radius, 4, normalize_correct(terrain.radius, 0, 1, terrain.brush_min, terrain.brush_max), t_general);
    t_general.element_brush_radius_bar = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_text(col2_x, yy, "Exporting Terrain", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "New Terrain", col_width, element_height, fa_center, ui_terrain_new, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Save Terrain", col_width, element_height, fa_center, uivc_terrain_save, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Load Terrain", col_width, element_height, fa_center, uivc_terrain_load, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Export Terrain", col_width, element_height, fa_center, uivc_terrain_export, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Export scale:", col_width, element_height, ui_input_terrain_save_scale, 0, terrain.save_scale, "0.01...100", validate_double, ui_value_real, 0.01, 100, 4, vx1 + 32, vy1, vx2, vy2, t_general);
    t_general.element_save_scale = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "Export: all faces?", col_width, element_height, ui_input_terrain_export_all, 0, terrain.export_all, t_general);
    t_general.element_save_all_faces = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: swap Z up?", col_width, element_height, ui_input_terrain_export_swap_zup, 0, terrain.export_swap_zup, t_general);
    t_general.element_swap_zup = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: swap UVs?", col_width, element_height, ui_input_terrain_export_swap_uvs, 0, terrain.export_swap_uvs, t_general);
    t_general.element_swap_uvs = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Import Heightmap", col_width, element_height, fa_center, ui_terrain_new, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Export Heightmap", col_width, element_height, fa_center, uivc_terrain_export_heightmap, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(col2_x, yy, "DDD Stuff", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Add to Project", col_width, element_height, fa_center, null, t_general);
    element.interactive = false;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: heightmap
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Deform", col_width, element_height, fa_center, uivc_terrain_set_mode_heightmap, t_general);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Reset Height", col_width, element_height, fa_center, uivc_terrain_reset_z, t_general);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Deformation mode:", col_width, element_height, ui_input_terrain_set_deform_mode, terrain.submode, t_heightmap);
    create_radio_array_options(element, ["Mound", "Average", "Flat Average", "Zero (Erase)"]);
    t_heightmap.element_deform_mode = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Deformation rate: " + string_format(terrain.rate, 1, 3), col_width, element_height, fa_left, col_width, t_heightmap);
    t_heightmap.element_deform_rate = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_deformation_rate, 4, normalize_correct(terrain.rate, 0, 1, terrain.rate_min, terrain.rate_max), t_heightmap);
    t_heightmap.element_deform_rate_bar = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: texture
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Texture", col_width, element_height, fa_center, uivc_terrain_set_mode_texture, t_general);
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
    
	element = create_button(legal_x + spacing, yy, "Save Texture", col_width, element_height, fa_center, uivc_terrain_export_texture, t_texture);
    ds_list_add(t_texture.contents, element);
    
	element = create_button(col2_x, yy, "Change Texture", col_width, element_height, fa_center, uivc_terrain_change_texture, t_texture);
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
	
    element = create_text(legal_x + spacing, yy, terrain.texture_name + " (" + string(terrain.texture_width) + " x " + string(terrain.texture_height) + ")", legal_width, element_height, fa_left, legal_width, t_texture);
    t_texture.element_texture_name = element;
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
	
    element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, legal_width - spacing * 2, uivc_select_terrain_tile, null, t_texture);
    element.tile_x = terrain.tile_brush_x;
    element.tile_y = terrain.tile_brush_y;
    element.tileset = terrain.texture;
    t_texture.element_tile_selector = element;
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
    
    var yy_aftergrid = yy;
    
    element = create_button(legal_x + spacing, yy, "Clear Texture", col_width, element_height, fa_center, uivc_terrain_clear_texture, t_general);
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: painting
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Paint", col_width, element_height, fa_center, uivc_terrain_set_mode_paint, t_general);
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Paint strength: " + string(terrain.paint_strength), col_width, element_height, fa_left, col_width, t_paint);
    t_paint.element_paint_strength = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_paint_strength, 4, normalize_correct(terrain.paint_strength, 0, 1, terrain.paint_strength_min, terrain.paint_strength_max), t_paint);
    t_paint.element_paint_strength_bar = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Paint precision: " + string(terrain.paint_precision), col_width, element_height, fa_left, col_width, t_paint);
    t_paint.element_paint_precision = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_paint_precision, 4, normalize_correct(terrain.paint_precision, 0, 1, terrain.paint_precision_min, terrain.paint_precision_max), t_paint);
    t_paint.element_paint_precision_bar = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_color_picker(legal_x + spacing, yy, "Color:", col_width, element_height, ui_input_terrain_set_paint_color, 0, terrain.paint_color, vx1, vy1, vx2, vy2, t_paint);
    element.allow_alpha = true;
    t_paint.element_paint_color = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Clear Color", col_width, element_height, fa_center, uivc_terrain_clear_color, t_general);
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    return id;
}