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
    
    element = create_checkbox(legal_x + spacing, yy, "Export squares below z = 0?", col_width, element_height, ui_input_terrain_export_below_z, 0, Stuff.terrain.save_under_z_0, t_general);
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
    
    #endregion
    
    #region tab: heightmap
    var yy = legal_y + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Deformation mode:", col_width, element_height, ui_input_terrain_set_deform_mode, Stuff.terrain.submode, t_general);
    create_radio_array_options(element, ["Mound", "Spike", "Average", "Flat Average", "Zero"]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    #endregion
    return id;
}