/// @description ui_init_main();

with (instantiate(UIMain)) {
    
    #region setup
    
    // it would be best if you don't ask to access these later but if you need to these are just
    // object variables so you can look them up
    t_general = create_tab("General", 0, id, HelpPages.TAB_GENERAL);
    t_stats = create_tab("Stats", 0, id);
    t_2 = create_tab("ehh", 0, id);
    
    t_p_tile_editor = create_tab("Tile Ed.", 1, id, HelpPages.TAB_TILE_EDITOR);
    t_p_autotile_editor = create_tab("Autotile Ed.", 1, id, HelpPages.TAB_AUTOTILE_EDITOR);
    t_p_mesh_editor = create_tab("Mesh Ed.", 1, id, HelpPages.TAB_MESH_EDITOR);
    t_p_other_editor = create_tab("Other Ed.", 1, id);
    
    t_p_entity = create_tab("Entity", 2, id, HelpPages.TAB_ENTITY);
    t_p_tile = create_tab("Tile", 2, id, HelpPages.TAB_TILE);
    t_p_mesh = create_tab("Mesh", 2, id, HelpPages.TAB_MESH);
    t_p_mob = create_tab("Mob", 2, id, HelpPages.TAB_MOB);
    t_p_effect = create_tab("Effect", 2, id, HelpPages.TAB_EFFECT);
    t_p_event = create_tab("Event", 2, id, HelpPages.TAB_EVENT);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_general, t_stats, t_2);
    var tr_editor = ds_list_create();
    ds_list_add(tr_editor, t_p_tile_editor, t_p_autotile_editor, t_p_mesh_editor, t_p_other_editor);
    var tr_world = ds_list_create();
    ds_list_add(tr_world, t_p_entity, t_p_tile, t_p_mesh, t_p_mob, t_p_effect, t_p_event);
    
    ds_list_add(tabs, tr_general, tr_editor, tr_world);
    
    active_tab = t_general;
    
    #endregion
    
    // don't try to make three columns. the math has been hard-coded
    // for two. everything will go very badly if you try three or more.
    var element;
    var spacing = 16;
    var legal_x = CW + 32;
    var legal_y = 128;
    var legal_width = ui_legal_width();
    var col_width = legal_width / 2 - spacing * 1.5;
    var col2_x = legal_x + col_width + spacing * 2;
    
    var vx1 = legal_width / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + 80;
    var vy2 = vy1 + 24;
    
    var button_width = 128;
    
    #region tab: general
    
    var yy = legal_y + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Selection mode", col_width, element_height, uivc_radio_selection_mode, Camera.selection_mode, t_general);
    create_radio_array_options(element, "Single", "Rectangle", "Circle");
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Additive Selection", col_width, element_height, uivc_check_selection_addition, "", Camera.selection_addition, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Fill Type", col_width, element_height, uivc_radio_fill_type, Camera.selection_fill_type, t_general);
    create_radio_array_options(element, "Tile", "Autotile", "Mesh", "Mob", "Effect", "Event", "Terrain");
    ds_list_add(t_general.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_button(legal_x + spacing, yy, "Fill Selection (Space)", col_width, element_height, fa_center, uimu_selection_fill, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Delete Selection (Delete)", col_width, element_height, fa_center, uimu_selection_delete, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    var s = 16;
    
    element = create_bitfield(legal_x + spacing, yy, "Selection Mask:", col_width, element_height, null, SELECTION_MASK_ALL, t_general);
    create_bitfield_options_vertical(element, create_bitfield_option_data(ETypeFlags.ENTITY_TILE, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Tile", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_TILE_AUTO, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Autotile", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_MESH, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Mesh", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_PAWN, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Pawn", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_EFFECT, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Effect", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_EVENT, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Event", -1, 0, col_width / 2, s),
        create_bitfield_option_data(SELECTION_MASK_ALL, ui_render_bitfield_option_text_selection_mask_all, uivc_bitfield_selection_mask_all, "All", -1, 0, col_width / 2, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_selection_mask_none, uivc_bitfield_selection_mask_none, "None", -1, 0, col_width / 2, s));
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_button(col2_x, yy, "View Master Texture", col_width, element_height, fa_center, uimu_view_master_texture, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Wireframes", col_width, element_height, uivc_check_view_wireframe, "", Camera.view_wireframe, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Grid and Markers", col_width, element_height, uivc_check_view_grids, "", Camera.view_grid, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Texture", col_width, element_height, uivc_check_view_texture, "", Camera.view_texture, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Entities", col_width, element_height, uivc_check_view_entities, "", Camera.view_entities, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Backfaces", col_width, element_height, uivc_check_view_backface, "", Camera.view_backface, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(col2_x, yy, "Map Settings", col_width, element_height, fa_left, col_width, t_general);
    ds_list_add(t_general.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x, yy, "Freeze Selected", col_width, element_height, fa_center, uimu_freeze_ask, t_general);
    ds_list_add(t_general.contents, element);
    
    #endregion
    
    #region tab: stats
    
    yy = legal_y + spacing;
    
    element_all_entities = create_list(legal_x + spacing, yy, "All Entities", "<No entities>", col_width, element_height, 28, null, true, t_stats);
    element_all_entities.render = ui_render_list_all_entities;
    ds_list_add(t_stats.contents, element_all_entities);
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_text(col2_x, yy, "Entity Stats", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    yy = yy + element.height + spacing;
    
    var stat_x = col2_x + col_width * 3 / 4;
    
    element = create_text(col2_x, yy, "Total Entities:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + element.height + spacing + spacing;
    
    element = create_text(col2_x, yy, "     Static:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_static;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Solid:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render=ui_render_text_stats_solid;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(col2_x, yy, "     Tiles:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_tiles;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Autotiles:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_tiles_auto;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Meshes:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_meshes;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Pawns:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_pawns;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Effects:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_effects;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    element = create_text(col2_x, yy, "     Events:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_events;
    ds_list_add(t_stats.contents, element);
    
    yy = yy + spacing;
    
    #endregion
    
    #region tab: entity
    
    yy = legal_y + spacing;
    
    draw_set_font(FDefault12);
    var max_characters = 18;
    vx2 = vx1 + string_width(string("m")) * max_characters + 32;
    
    element_entity_name = create_input(legal_x + spacing, yy, "Name: ", col_width, element_height, uivc_input_entity_name, "", "", "Helpful if unique", validate_string, ui_value_string, 0, 1, max_characters, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_name);
    element_entity_name.interactive = false;
    
    vx2 = vx1 + 80;
    yy = yy + element_entity_name.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Basic Properties", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element.height + spacing;
    
    element_entity_solid = create_checkbox(legal_x + spacing, yy, "Solid", col_width, element_height, uivc_check_entity_solid, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_solid);
    element_entity_solid.interactive = false;
    
    yy = yy + element_entity_solid.height + spacing;
    
    element_entity_static = create_checkbox(legal_x + spacing, yy, "Static", col_width, element_height, uivc_check_entity_static, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_static);
    element_entity_static.interactive = false;
    
    yy = yy + element_entity_static.height + spacing;
    
    var n = 6;
    
    element_entity_events = create_list(legal_x + spacing, yy, "Event Pages", "<No events>", col_width, element_height, n, null, false, t_p_entity);
    element_entity_events.colorize = false;
    element_entity_events.render = ui_render_list_entity_events;
    element_entity_events.entries_are = ListEntries.INSTANCES;
    ds_list_add(t_p_entity.contents, element_entity_events);
    element_entity_events.interactive = false;
    
    yy = yy + element_height * n + spacing + spacing;
    
    element_entity_event_edit = create_button(legal_x + spacing, yy, "Edit Event Page", col_width, element_height, fa_center, omu_entity_event_page, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_event_edit);
    element_entity_event_edit.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_event_add = create_button(legal_x + spacing, yy, "Add Event Page", col_width, element_height, fa_center, omu_entity_add_event, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_event_add);
    element_entity_event_add.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_event_remove = create_button(legal_x + spacing, yy, "Delete Event Page", col_width, element_height, fa_center, omu_entity_remove_event, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_event_remove);
    element_entity_event_remove.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Options", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element.height + spacing;
    
    element_entity_option_animate_idle = create_checkbox(legal_x + spacing, yy, "Animate Idle", col_width, element_height, uivc_check_entity_option_animate_idle, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_animate_idle);
    element_entity_option_animate_idle.interactive = false;
    
    yy = yy + element_entity_option_animate_idle.height + spacing;
    
    element_entity_option_animate_movement = create_checkbox(legal_x + spacing, yy, "Animate Movement", col_width, element_height, uivc_check_entity_option_animate_movement, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_animate_movement);
    element_entity_option_animate_movement.interactive = false;
    
    yy = yy + element_entity_option_animate_movement.height + spacing;
    
    element_entity_option_direction_fix = create_checkbox(legal_x + spacing, yy, "Direction Fix", col_width, element_height, uivc_check_entity_option_direction_fix, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_direction_fix);
    element_entity_option_direction_fix.interactive = false;
    
    yy = yy + element_entity_option_direction_fix.height + spacing;
    
    element_entity_option_reset_position = create_checkbox(legal_x + spacing, yy, "Reset Position", col_width, element_height, uivc_check_entity_option_reset_position, "", false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_reset_position);
    element_entity_option_reset_position.interactive = false;
    
    yy = yy + element_entity_option_reset_position.height + spacing;
    
    element_entity_option_autonomous_movement = create_button(legal_x + spacing, yy, "Autonomous Movement", col_width, element_height, fa_center, omu_entity_autonomous_movement, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_autonomous_movement);
    element_entity_option_autonomous_movement.interactive = false;
    
    yy = yy + element_entity_option_autonomous_movement.height + spacing;
    
    // second column
    
    yy = legal_y + spacing + element_entity_name.height + spacing;
    
    element = create_text(col2_x, yy, "Transform: Position", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element_height + spacing;
    
    element_entity_pos_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_pos_x, "", "", "Cell", validate_int, ui_value_real, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_pos_x);
    element_entity_pos_x.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_pos_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_pos_y, "", "", "Cell", validate_int, ui_value_real, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_pos_y);
    element_entity_pos_y.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_pos_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_pos_z, "", "", "Cell", validate_int, ui_value_real, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_pos_z);
    element_entity_pos_z.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element = create_text(col2_x, yy, "Transform: Position Offset", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element_height + spacing;
    
    element_entity_offset_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_off_x, "", "", "0...1", validate_double, ui_value_real, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_offset_x);
    element_entity_offset_x.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_offset_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_off_y, "", "", "0...1", validate_double, ui_value_real, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_offset_y);
    element_entity_offset_y.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_offset_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_off_z, "", "", "0...1", validate_double, ui_value_real, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_offset_z);
    element_entity_offset_z.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element = create_text(col2_x, yy, "Transform: Rotation", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element_height + spacing;
    
    element_entity_rot_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_rotate_x, "", "", "Degrees", validate_int, ui_value_real, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_rot_x);
    element_entity_rot_x.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_rot_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_rotate_y, "", "", "Degrees", validate_int, ui_value_real, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_rot_y);
    element_entity_rot_y.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_rot_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_rotate_z, "", "", "Degrees", validate_int, ui_value_real, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_rot_z);
    element_entity_rot_z.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element = create_text(col2_x, yy, "Transform: Scale", col_width, element_height, fa_left, col_width, t_p_entity);
    ds_list_add(t_p_entity.contents, element);
    
    yy = yy + element_height + spacing;
    
    element_entity_scale_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_scale_x, "", "", "0.1...10", validate_double, ui_value_real, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_scale_x);
    element_entity_scale_x.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_scale_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_scale_y, "", "", "0.1...10", validate_double, ui_value_real, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_scale_y);
    element_entity_scale_y.interactive = false;
    
    yy = yy + element_height + spacing;
    
    element_entity_scale_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_scale_z, "", "", "0.1...10", validate_double, ui_value_real, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_scale_z);
    element_entity_scale_z.interactive = false;
    
    yy = yy + element_height + spacing;
    
    #endregion
    
    #region tab: entity-mob
    
    yy = legal_y + spacing;
    
    element_entity_mob_frame = create_input(legal_x + spacing, yy, "Editor frame:", col_width, element_height, uivc_entity_mob_editor_frame, "", 0, "0...3", validate_int, ui_value_real, 0, 3, 1, vx1, vy1, vx2, vy2, t_p_mob);
    ds_list_add(t_p_mob.contents, element_entity_mob_frame);
    
    yy = yy + element_entity_mob_frame.height + spacing;
    
    element_entity_mob_direction = create_radio_array(legal_x + spacing, yy, "Direction", col_width, element_height, uivc_entity_mob_direction, 0, t_p_mob);
    create_radio_array_options(element_entity_mob_direction, "Down", "Left", "Right", "Up");
    ds_list_add(t_p_mob.contents, element_entity_mob_direction);
    
    yy = yy + ui_get_radio_array_height(element_entity_mob_direction) + spacing;
    
    element_entity_mob_animating = create_checkbox(legal_x + spacing, yy, "Animating", col_width, element_height, uivc_entity_mob_animating, "", false, t_p_mob);
    ds_list_add(t_p_mob.contents, element_entity_mob_animating);
    
    yy = yy + element_entity_mob_animating.height + spacing;
    
    #endregion
    
    #region tab: tiles
    
    yy = legal_y + spacing;
    
    element = create_text(legal_x + spacing, yy, "Select a tile to place down!", col_width, element_height, fa_left, col_width, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    element = create_button(col2_x + col_width / 2, yy, "Tileset Data", button_width, element_height, fa_center, omu_manager_tileset, t_p_tile_editor, HelpPages.TAB_TILE_EDITOR, fa_middle, fa_top);
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, (legal_width div Stuff.tile_width) * Stuff.tile_width - element_height, uivc_select_tile, uivc_select_tile_backwards, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    var yy_aftergrid = yy;
    
    element = create_radio_array(legal_x + spacing, yy, "Data to View", col_width, element_height, uivc_tile_set_data_view, Camera.tile_data_view, t_p_tile_editor);
    create_radio_array_options(element, "Passage", "Priority", "Flags (off)", "Tags");
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "On Click", col_width, element_height, uivc_tile_set_on_click, Camera.tile_on_click, t_p_tile_editor);
    create_radio_array_options(element, "Select", "Modify");
    ds_list_add(t_p_tile_editor.contents, element);
    
    // second column
    
    yy = yy_aftergrid;
    
    element = create_text(col2_x, yy, "Tile Properties: x, y", col_width, element_height, fa_left, col_width, t_p_tile_editor);
    element.render = ui_render_text_tile_label;
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    var s = 10;
    
    element = create_bitfield(col2_x, yy, "Passage:", 84, element_height, null, TILE_PASSABLE, t_p_tile_editor);
    create_bitfield_options(element, create_bitfield_option_data(TilePassability.UP, ui_render_bitfield_option_picture_tile_passability, uivc_bitfield_tile_passability, "", spr_direction, 0, s, s),
        create_bitfield_option_data(TilePassability.DOWN, ui_render_bitfield_option_picture_tile_passability, uivc_bitfield_tile_passability, "", spr_direction, 1, s, s),
        create_bitfield_option_data(TilePassability.LEFT, ui_render_bitfield_option_picture_tile_passability, uivc_bitfield_tile_passability, "", spr_direction, 2, s, s),
        create_bitfield_option_data(TilePassability.RIGHT, ui_render_bitfield_option_picture_tile_passability, uivc_bitfield_tile_passability, "", spr_direction, 3, s, s),
        create_bitfield_option_data(TILE_PASSABLE, ui_render_bitfield_option_text_passability_tile_passable, uivc_bitfield_tile_passability_passable, "O", spr_direction, 0, s, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_passability_tile_solid, uivc_bitfield_tile_passability_solid, "X", spr_direction, 0, s, s));
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Priority:", col_width, element_height, uivc_input_tile_priority, "", 0, 0, validate_int, ui_value_real, 0, TILE_MAX_PRIORITY - 1, 3, 84, 0, 84 + 64, element_height, t_p_tile_editor);
    element.render = ui_render_input_tile_priority;
    ds_list_add(t_p_tile_editor.contents, element);
    
    t_p_tile_editor.element_priority = element;
    
    yy = yy + element.height + spacing;
    
    element = create_bitfield(col2_x, yy, "Flags:", 84, element_height, fa_left, col_width, t_p_tile_editor);
    create_bitfield_options(element, create_bitfield_option_data(TileFlags.BUSH, ui_render_bitfield_option_text_tile_flag, uivc_bitfield_tile_flag, "B", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.COUNTER, ui_render_bitfield_option_text_tile_flag, uivc_bitfield_tile_flag, "C", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.DANGER, ui_render_bitfield_option_text_tile_flag, uivc_bitfield_tile_flag, "D", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.SAFER, ui_render_bitfield_option_text_tile_flag, uivc_bitfield_tile_flag, "S", -1, 0, s, s));
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Tag:", col_width, element_height, uivc_input_tile_tag, "", 0, 0, validate_int, ui_value_real, 0, TileTerrainTags.FINAL - 1, 2, 84, 0, 84 + 64, element_height, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    t_p_tile_editor.element_tag = element;
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x + 16, yy, "-", element_height, element_height, fa_center, uimu_tile_tag_down, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    element = create_text(col2_x + 48, yy, "tag name", col_width, element_height, fa_left, 128, t_p_tile_editor);
    element.render = ui_render_text_tile_tag;
    ds_list_add(t_p_tile_editor.contents, element);
    element = create_button(col2_x + 176, yy, "+", element_height, element_height, fa_center, uimu_tile_tag_up, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    #endregion
    
    #region tab: meshes
    
    yy = legal_y + spacing;
    
    // this is an object variable
    element_mesh_list = create_list(legal_x + spacing, yy, "Available meshes: ", "<no meshes>", col_width, element_height, 28, uivc_list_selection_mesh, false, t_p_mesh_editor);
    ds_map_add(element_mesh_list.selected_entries, 0, true);
    // NOT POPULATED YET. the meshes haven't been loaded in yet. it gets populated when that happens.
    ds_list_add(t_p_mesh_editor.contents, element_mesh_list);
    
    element = create_text(col2_x, yy, "Mesh Properties:", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(col2_x, yy, "<Name>", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
    element.render = ui_render_text_mesh_name;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    var s = 10;
    
    yy = yy + element.height + spacing;
    
    element = create_bitfield(col2_x, yy, "Passage:", 84, element_height, null, TILE_PASSABLE, t_p_mesh_editor);
    create_bitfield_options(element, create_bitfield_option_data(TilePassability.UP, ui_render_bitfield_option_picture_mesh_passability, uivc_bitfield_mesh_passability, "", spr_direction, 0, s, s),
        create_bitfield_option_data(TilePassability.DOWN, ui_render_bitfield_option_picture_mesh_passability, uivc_bitfield_mesh_passability, "", spr_direction, 1, s, s),
        create_bitfield_option_data(TilePassability.LEFT, ui_render_bitfield_option_picture_mesh_passability, uivc_bitfield_mesh_passability, "", spr_direction, 2, s, s),
        create_bitfield_option_data(TilePassability.RIGHT, ui_render_bitfield_option_picture_mesh_passability, uivc_bitfield_mesh_passability, "", spr_direction, 3, s, s),
        create_bitfield_option_data(TILE_PASSABLE, ui_render_bitfield_option_text_passability_mesh_passable, uivc_bitfield_mesh_passability_passable, "O", spr_direction, 0, s, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_passability_mesh_solid, uivc_bitfield_mesh_passability_solid, "X", spr_direction, 0, s, s));
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_bitfield(col2_x, yy, "Flags:", 84, element_height, fa_left, col_width, t_p_mesh_editor);
    create_bitfield_options(element, create_bitfield_option_data(TileFlags.BUSH, ui_render_bitfield_option_text_mesh_flag, uivc_bitfield_mesh_flag, "B", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.COUNTER, ui_render_bitfield_option_text_mesh_flag, uivc_bitfield_mesh_flag, "C", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.DANGER, ui_render_bitfield_option_text_mesh_flag, uivc_bitfield_mesh_flag, "D", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.SAFER, ui_render_bitfield_option_text_mesh_flag, uivc_bitfield_mesh_flag, "S", -1, 0, s, s));
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Tag:", col_width, element_height, uivc_input_mesh_tag, "", 0, 0, validate_int, ui_value_real, 0, TileTerrainTags.FINAL-1, 2, 84, 0, 84+64, element_height, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    t_p_mesh_editor.element_tag=element;
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x + 16, yy, "-", element_height, element_height, fa_center, uimu_mesh_tag_down, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    element = create_text(col2_x + 48, yy, "tag name", col_width, element_height, fa_left, 128, t_p_mesh_editor);
    element.render = ui_render_text_mesh_tag;
    ds_list_add(t_p_mesh_editor.contents, element);
    element = create_button(col2_x + 176, yy, "+", element_height, element_height, fa_center, uimu_mesh_tag_up, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    var bounds_x = col2_x;
    var bounds_x_2 = bounds_x + col_width / 2;
    
    element = create_text(bounds_x, yy, "Bounds:", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(bounds_x, yy, "N/A", col_width / 2, element_height, fa_left, col_width / 2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_xmin;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    element = create_text(bounds_x_2, yy, "N/A", col_width / 2, element_height, fa_left, col_width / 2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_xmax;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(bounds_x, yy, "N/A", col_width / 2, element_height, fa_left, col_width / 2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_ymin;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    element = create_text(bounds_x_2, yy, "N/A", col_width / 2, element_height, fa_left, col_width / 2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_ymax;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_text(bounds_x, yy, "N/A", col_width/2, element_height, fa_left, col_width/2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_zmin;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    element = create_text(bounds_x_2, yy, "N/A", col_width/2, element_height, fa_left, col_width/2, t_p_mesh_editor);
    //element.render = ui_render_text_mesh_zmax;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    #endregion
    
    #region tab: autotiles
    
    yy = legal_y + spacing;
    
    element = create_list(legal_x + spacing, yy, "Defined Autotiles: ", "<something is wrong>", col_width, element_height, 28, uivc_list_selection_autotile, false, t_p_autotile_editor);
    ds_map_add(element.selected_entries, 0, true);
    for (var i = 0; i<AUTOTILE_MAX; i++) {
        create_list_entries(element, string(i) + ". <none set>", c_black);
    }
    ds_list_add(t_p_autotile_editor.contents, element);
    
    t_p_autotile_editor.element_list = element;
    
    element = create_text(col2_x, yy, "Autotile Properties:", col_width, element_height, fa_left, col_width, t_p_autotile_editor);
    ds_list_add(t_p_autotile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    var s = 10;
    
    element = create_bitfield(col2_x, yy, "Passage:", 84, element_height, null, TILE_PASSABLE, t_p_autotile_editor);
    create_bitfield_options(element, create_bitfield_option_data(TilePassability.UP, ui_render_bitfield_option_picture_autotile_passability, uivc_bitfield_autotile_passability, "", spr_direction, 0, s, s),
        create_bitfield_option_data(TilePassability.DOWN, ui_render_bitfield_option_picture_autotile_passability, uivc_bitfield_autotile_passability, "", spr_direction, 1, s, s),
        create_bitfield_option_data(TilePassability.LEFT, ui_render_bitfield_option_picture_autotile_passability, uivc_bitfield_autotile_passability, "", spr_direction, 2, s, s),
        create_bitfield_option_data(TilePassability.RIGHT, ui_render_bitfield_option_picture_autotile_passability, uivc_bitfield_autotile_passability, "", spr_direction, 3, s, s),
        create_bitfield_option_data(TILE_PASSABLE, ui_render_bitfield_option_text_passability_autotile_passable, uivc_bitfield_autotile_passability_passable, "O", spr_direction, 0, s, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_passability_autotile_solid, uivc_bitfield_autotile_passability_solid, "X", spr_direction, 0, s, s));
    ds_list_add(t_p_autotile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Priority:", col_width, element_height, uivc_input_autotile_priority, "", 0, 0, validate_int, ui_value_real, 0, TILE_MAX_PRIORITY - 1, 3, 84, 0, 84 + 64, element_height, t_p_autotile_editor);
    element.render = ui_render_input_tile_priority;
    ds_list_add(t_p_autotile_editor.contents, element);
    
    // this is totally cheating but game maker allows me to do it so shut up
    t_p_autotile_editor.element_priority=element;
    
    yy = yy + element.height + spacing;
    
    element = create_bitfield(col2_x, yy, "Flags:", 84, element_height, fa_left, col_width, t_p_autotile_editor);
    create_bitfield_options(element, create_bitfield_option_data(TileFlags.BUSH, ui_render_bitfield_option_autotext_tile_flag, uivc_bitfield_autotile_flag, "B", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.COUNTER, ui_render_bitfield_option_text_autotile_flag, uivc_bitfield_autotile_flag, "C", -1, 0, s, s),
        create_bitfield_option_data(TileFlags.SAFER, ui_render_bitfield_option_text_autotile_flag, uivc_bitfield_autotile_flag, "S", -1, 0, s, s));
    ds_list_add(t_p_autotile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_input(col2_x, yy, "Tag:", col_width, element_height, uivc_input_autotile_tag, "", 0, 0, validate_int, ui_value_real, 0, TileTerrainTags.FINAL - 1, 2, 84, 0, 84 + 64, element_height, t_p_autotile_editor);
    ds_list_add(t_p_autotile_editor.contents, element);
    
    t_p_autotile_editor.element_tag = element;
    
    yy = yy + element.height + spacing;
    
    element = create_button(col2_x+16, yy, "-", element_height, element_height, fa_center, uimu_autotile_tag_down, t_p_autotile_editor);
    ds_list_add(t_p_autotile_editor.contents, element);
    element = create_text(col2_x+48, yy, "tag name", col_width, element_height, fa_left, 128, t_p_autotile_editor);
    element.render = ui_render_text_autotile_tag;
    ds_list_add(t_p_autotile_editor.contents, element);
    element = create_button(col2_x+176, yy, "+", element_height, element_height, fa_center, uimu_autotile_tag_up, t_p_autotile_editor);
    ds_list_add(t_p_autotile_editor.contents, element);
    
    yy = yy + element.height + spacing;
    
    element = create_image_button(col2_x, yy, "(Click for autotile)", noone, col_width, col_width, fa_center, omu_autotile_selector, t_p_autotile_editor);
    element.render = ui_render_image_button_autotile;
    ds_list_add(t_p_autotile_editor.contents, element);
    
    #endregion
    
    #region tab: other
    
    yy = legal_y + spacing;
    
    element = create_text(legal_x + spacing, yy, "We also need to be able to manage particle (image), npc (image), follower (image), ui (image), se (audio), bgm (audio), and possibly some other asset types but there's not enough space here; those might just be done with other items in the Data menu",
        legal_width - spacing * 2, element_height, fa_left, legal_width - spacing * 2, t_p_other_editor);
    element.valignment = fa_top;
    ds_list_add(t_p_other_editor.contents, element);
    
    #endregion
    
    return id;
}