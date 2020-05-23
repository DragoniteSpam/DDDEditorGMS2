/// @param EditorModeSpart

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIMain)) {
    #macro PART_MAXIMUM_EMITTERS 8
    #macro PART_MAXIMUM_TYPES 255
    
    var columns = 3;
    var spacing = 16;
    var legal_x = 32;
    var legal_y = home_row_y + 32;
    var legal_width = (room_width / 2) - 64;
    
    var col_width = legal_width / columns;
    var ew = col_width - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    var header = create_text(32, 32, "[FDefault20][#0000ff]Particle Editor[]", 10000, eh, fa_left, 10000, id);
    header.use_scribble = true;
    ds_list_add(contents, header);
    
    // it would be best if you don't ask to access these later but if you need to these are just
    // object variables so you can look them up
    t_system = create_tab("System", 0, id);
    t_emitter = create_tab("Emitters", 0, id);
    t_type = create_tab("Types", 0, id);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_system, t_emitter, t_type);
    
    ds_list_add(tabs, tr_general);
    
    active_tab = t_system;
    
    var spacing = 16;
    var col1_x = legal_x + col_width * 0 + spacing;
    var col2_x = legal_x + col_width * 1 + spacing;
    var col3_x = legal_x + col_width * 2 + spacing;
    
    var button_width = 128;
    
    #region tab: system
    var yy = legal_y + spacing;
    
    var element = create_color_picker(col1_x, yy, "Back:", ew, eh, ui_particle_back_color, mode.back_color, vx1, vy1, vx2, vy2, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col1_x, yy, "Automatic Update?", ew, eh, ui_particle_automatic_update, mode.system_auto_update, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Update", ew, eh, fa_center, ui_particle_manual_update, t_system);
    element.interactive = !mode.system_auto_update;
    ds_list_add(t_system.contents, element);
    t_system.manual_update = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Clear All Particles", ew, eh, fa_center, ui_particle_clear_particles, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Reset System", ew, eh, fa_center, ui_particle_reset, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    #endregion
    
    #region tab: emitters
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Emitters", "<no emitters>", ew, eh, 24, ui_particle_emitter_select, false, t_emitter, mode.emitters);
    element.entries_are = ListEntries.INSTANCES;
    t_emitter.list = element;
    ds_list_add(t_emitter.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Emitter", ew, eh, fa_center, ui_particle_emitter_add, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Emitter", ew, eh, fa_center, ui_particle_emitter_remove, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", ew, eh, ui_particle_emitter_rename, "Part Emitter", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.name = element;
    
    yy += element.height + spacing;
    
    var element = create_radio_array(col2_x, yy, "Shape:", ew, eh, ui_particle_emitter_shape, PartEmitterShapes.ELLIPSE, t_emitter);
    create_radio_array_options(element, ["Rectangle", "Ellipse", "Diamond", "Line"]);
    ds_list_add(t_emitter.contents, element);
    t_emitter.shape = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_radio_array(col2_x, yy, "Distribution:", ew, eh, ui_particle_emitter_distribution, PartEmitterDistributions.LINEAR, t_emitter);
    create_radio_array_options(element, ["Linear", "Gaussian", "Inverse Gaussian"]);
    ds_list_add(t_emitter.contents, element);
    t_emitter.distr = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_button(col2_x, yy, "Set Region", ew, eh, fa_center, null, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var ovx1 = ew / 4;
    var ovy1 = 0;
    var ovx2 = ew / 2;
    var ovy2 = eh;
    
    var element = create_input(col2_x, yy, "X1:", ew, eh, ui_particle_emitter_xmin, 160, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmin = element;
    
    var element = create_input(col2_x + ew / 2, yy, "Y1:", ew, eh, ui_particle_emitter_ymin, 160, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymin = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "X2:", ew, eh, ui_particle_emitter_xmax, 240, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmax = element;
    
    var element = create_input(col2_x + ew / 2, yy, "Y2:", ew, eh, ui_particle_emitter_ymax, 240, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymax = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col2_x, yy, "Streaming?", ew, eh, ui_particle_emitter_streaming, false, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.streaming = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Rate", ew, eh, ui_particle_emitter_rate, 120, "", validate_double, 0, 999, 5, vx1, vy1, vx2, vy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.rate = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "Burst", ew, eh, fa_center, ui_particle_emitter_burst, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: types
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Types", "<no particle types>", ew, eh, 24, ui_particle_type_select, false, t_type, mode.types);
    element.entries_are = ListEntries.INSTANCES;
    t_type.list = element;
    ds_list_add(t_type.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Type", ew, eh, fa_center, ui_particle_type_add, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Type", ew, eh, fa_center, ui_particle_type_remove, t_type);
    ds_list_add(t_type.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", ew, eh, ui_particle_type_rename, "Part Type", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.name = element;
    
    yy += element.height + spacing;
    
    var element = create_list(col2_x, yy, "Shape:", "", ew, eh, 6, null, false, t_type);
    create_list_entries(element, "Pixel", "Disk", "Square", "Line", "Star", "Circle", "Ring", "Sphere", "Flare", "Spark", "Explosion", "Cloud", "Smoke", "Snow");
    ds_list_add(t_type.contents, element);
    t_type.shape = element;
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_text(col2_x, yy, "Speed:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "min:", ew, eh, null, 160, "float", validate_double, -400, 400, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.speed_min = element;
    
    var element = create_input(col2_x + ew / 2, yy, "max:", ew, eh, null, 160, "float", validate_double, -400, 400, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.speed_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.speed_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.speed_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Direction:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, null, 4, 0, t_type);
    ds_list_add(t_type.contents, element);
    t_type.direction_min = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, null, 4, 0, t_type);
    ds_list_add(t_type.contents, element);
    t_type.direction_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.direction_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.direction_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Orientation:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, null, 4, 0, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation_min = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, null, 4, 0, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, null, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col2_x, yy, "Relative?", ew, eh, null, false, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation_relative = element;
    
    yy = legal_y + spacing;
    
    var element = create_text(col3_x, yy, "Color and Size", ew, eh, fa_left, ew, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_color_picker(col3_x, yy, "Color:", ew, eh, ui_particle_back_color, mode.back_color, vx1, vy1, vx2, vy2, t_system);
    ds_list_add(t_type.contents, element);
    t_type.base_color = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col3_x, yy, "Life and Death", ew, eh, fa_left, ew, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col3_x, yy, "Lifetime:", ew, eh, null, 0, "seconds", validate_double, 0, 60, 3, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.lifetime = element;
    
    #endregion
    
    return id;
}