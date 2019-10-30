with (instance_create_depth(0, 0, 0, UIMain)) {
    home_row_y = 32;
    
    #region setup
    var t_heightmap = create_tab("Heightmap", 0, id);
    var t_texture = create_tab("Texture", 0, id);
    var t_paint = create_tab("Paint", 0, id);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_heightmap, t_texture, t_paint);
    
    ds_list_add(tabs, tr_general);
    
    active_tab = t_heightmap;
    
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
    
    element = create_radio_array(legal_x + spacing, yy, "Selection mode", col_width, element_height, uivc_radio_selection_mode, Camera.selection_mode, t_heightmap);
    create_radio_array_options(element, ["Single", "Rectangle", "Circle"]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Additive Selection", col_width, element_height, uivc_check_selection_addition, "", Camera.selection_addition, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Fill Type", col_width, element_height, uivc_radio_fill_type, Camera.selection_fill_type, t_heightmap);
    create_radio_array_options(element, ["Tile", "Autotile", "Mesh", "Pawn", "Effect", "Terrain"]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_button(legal_x + spacing, yy, "Fill Selection (Space)", col_width, element_height, fa_center, uimu_selection_fill, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Delete Selection (Delete)", col_width, element_height, fa_center, uimu_selection_delete, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    var s = 16;
    
    element = create_bitfield(legal_x + spacing, yy, "Selection Mask:", col_width, element_height, null, SELECTION_MASK_ALL, t_heightmap);
    create_bitfield_options_vertical(element, [create_bitfield_option_data(ETypeFlags.ENTITY_TILE, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Tile", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_TILE_AUTO, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Autotile", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_MESH, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Mesh", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_PAWN, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Pawn", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_EFFECT, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Effect", -1, 0, col_width / 2, s),
        create_bitfield_option_data(SELECTION_MASK_ALL, ui_render_bitfield_option_text_selection_mask_all, uivc_bitfield_selection_mask_all, "All", -1, 0, col_width / 2, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_selection_mask_none, uivc_bitfield_selection_mask_none, "None", -1, 0, col_width / 2, s)]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_button(col2_x, yy, "View Master Texture", col_width, element_height, fa_center, uimu_view_master_texture, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Wireframes", col_width, element_height, uivc_check_view_wireframe, "", Camera.view_wireframe, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Grid and Markers", col_width, element_height, uivc_check_view_grids, "", Camera.view_grid, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Texture", col_width, element_height, uivc_check_view_texture, "", Camera.view_texture, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Entities", col_width, element_height, uivc_check_view_entities, "", Camera.view_entities, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Backfaces", col_width, element_height, uivc_check_view_backface, "", Camera.view_backface, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(col2_x, yy, "Map Settings", col_width, element_height, fa_left, col_width, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Freeze Selected", col_width, element_height, fa_center, uimu_freeze_ask, t_heightmap);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(col2_x, yy, "Mouse Drag Action", col_width, element_height, uivc_radio_mouse_drag_behavior, Camera.mouse_drag_behavior, t_heightmap);
    create_radio_array_options(element, ["Default", "Translate Selection", "Offset Selection", "Rotate Selection", "Scale Selection"]);
    ds_list_add(t_heightmap.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    #endregion
    
    return id;
}