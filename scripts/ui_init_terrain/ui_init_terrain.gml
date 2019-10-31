with (instance_create_depth(0, 0, 0, UIMain)) {
    home_row_y = 32;
    
    #region setup
    var t_general = create_tab("General", 0, id);
    var t_heightmap = create_tab("Heightmap", 0, id);
    var t_texture = create_tab("Texture", 0, id);
    var t_paint = create_tab("Paint", 0, id);
    
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
    
    element = create_input(legal_x + spacing, yy, "Save scale:", col_width, element_height, ui_input_terrain_save_scale, 0, Stuff.terrain.save_scale, "0.01...100", validate_double, ui_value_real, 0.01, 100, 4, vx1, vy1, vx2, vy2, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Draw water?", col_width, element_height, ui_input_terrain_draw_water, 0, Stuff.terrain.view_water, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Mode:", col_width, element_height, ui_input_terrain_set_mode, Stuff.terrain.mode, t_general);
    create_radio_array_options(element, ["Heightmap", "Texture", "Paint"]);
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Brush shape:", col_width, element_height, ui_input_terrain_set_brush_shape, Stuff.terrain.style, t_general);
    create_radio_array_options(element, ["Block", "Circle", "Round Block"]);
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Brush radius: " + string(Stuff.terrain.radius) + " cells", col_width, element_height, fa_left, col_width, t_general);
    t_general.element_brush_radius = element;
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_brush_radius, 4, normalize_correct(Stuff.terrain.radius, 0, 1, Stuff.terrain.brush_min, Stuff.terrain.brush_max), t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_button(col2_x, yy, "Export", col_width, element_height, fa_center, uivc_terrain_export, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "Export: all faces?", col_width, element_height, ui_input_terrain_export_all, 0, Stuff.terrain.export_all, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: swap Z up?", col_width, element_height, ui_input_terrain_export_swap_zup, 0, Stuff.terrain.export_swap_zup, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: swap texture UVs?", col_width, element_height, ui_input_terrain_export_swap_uvs, 0, Stuff.terrain.export_swap_uvs, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: heightmap
    var yy = legal_y + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Deformation mode:", col_width, element_height, ui_input_terrain_set_deform_mode, Stuff.terrain.submode, t_heightmap);
    create_radio_array_options(element, ["Mound", "Average", "Flat Average", "Zero (Erase)"]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Deformation rate: " + string_format(Stuff.terrain.rate, 1, 3), col_width, element_height, fa_left, col_width, t_heightmap);
    t_heightmap.element_rate = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_deformation_rate, 4, normalize_correct(Stuff.terrain.rate, 0, 1, Stuff.terrain.rate_min, Stuff.terrain.rate_max), t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: texture
    var yy = legal_y + spacing;
    
	element = create_button(legal_x + spacing, yy, "Change Tileset", 128, element_height, fa_center, omu_manager_tileset, t_texture);
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
	
    element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, legal_width - spacing * 2, uivc_select_terrain_tile, null, t_texture);
    element.tile_x = Stuff.terrain.tile_brush_x;
    element.tile_y = Stuff.terrain.tile_brush_y;
    ds_list_add(t_texture.contents, element);
    
    yy = yy + element.height + spacing;
    var yy_aftergrid = yy;
    
    #endregion
    
    #region tab: painting
    var yy = legal_y + spacing;
    
    element = create_text(legal_x + spacing, yy, "Paint strength: " + string(Stuff.terrain.paint_strength), col_width, element_height, fa_left, col_width, t_paint);
    t_paint.element_paint_strength = element;
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_paint_strength, 4, normalize_correct(Stuff.terrain.paint_strength, 0, 1, Stuff.terrain.paint_strength_min, Stuff.terrain.paint_strength_max), t_paint);
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_color_picker(legal_x + spacing, yy, "Color:", col_width, element_height, ui_input_terrain_set_paint_color, 0, Stuff.terrain.paint_color, vx1, vy1, vx2, vy2, t_paint);
    ds_list_add(t_paint.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    return id;
}