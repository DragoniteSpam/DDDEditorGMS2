/// @param EditorModeSpart

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIMain)) {
    #macro PART_MAXIMUM_EMITTERS 8
    #macro PART_MAXIMUM_TYPES 255
    
    var columns = 3;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
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
    
    var header = create_text(32, 32, "[FDefault20][#0000ff]Particle Editor[]", ew, eh, fa_left, ew, id);
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
    
    // don't try to make three columns. the math has been hard-coded
    // for two. everything will go very badly if you try three or more.
    var element;
    var spacing = 16;
    var legal_x = 32;
    var legal_y = home_row_y + 32;
    var legal_width = ui_legal_width();
    var col_width = legal_width / 2 - spacing * 1.5;
    var col1_x = legal_x + spacing;
    var col2_x = legal_x + col_width + spacing * 2;
    
    var vx1 = col_width / 2;
    var vy1 = 0;
    var vx2 = col_width;
    var vy2 = eh;
    
    var button_width = 128;
    
    #region tab: system
    var yy = legal_y + spacing;
    
    var element = create_color_picker(col1_x, yy, "Back:", col_width, eh, ui_particle_back_color, mode.back_color, vx1, vy1, vx2, vy2, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col1_x, yy, "Automatic Update?", col_width, eh, ui_particle_automatic_update, mode.system_auto_update, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Update", col_width, eh, fa_center, ui_particle_manual_update, t_system);
    element.interactive = !mode.system_auto_update;
    ds_list_add(t_system.contents, element);
    t_system.manual_update = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Clear All Particles", col_width, eh, fa_center, ui_particle_clear_particles, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Reset System", col_width, eh, fa_center, ui_particle_reset, t_system);
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    #endregion
    
    #region tab: emitters
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Emitters", "<no emitters>", col_width, eh, 24, ui_particle_emitter_select, false, t_emitter, mode.emitters);
    element.entries_are = ListEntries.INSTANCES;
    t_emitter.list = element;
    ds_list_add(t_emitter.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Emitter", col_width, eh, fa_center, ui_particle_emitter_add, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Emitter", col_width, eh, fa_center, ui_particle_emitter_remove, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", col_width, eh, ui_particle_emitter_rename, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.name = element;
    
    yy += element.height + spacing;
    
    var element = create_radio_array(col2_x, yy, "Shape:", col_width, eh, ui_particle_emitter_shape, PartEmitterShapes.ELLIPSE, t_emitter);
    create_radio_array_options(element, ["Rectangle", "Ellipse", "Diamond", "Line"]);
    ds_list_add(t_emitter.contents, element);
    t_emitter.shape = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_radio_array(col2_x, yy, "Distribution:", col_width, eh, ui_particle_emitter_distribution, PartEmitterDistributions.LINEAR, t_emitter);
    create_radio_array_options(element, ["Linear", "Gaussian", "Inverse Gaussian"]);
    ds_list_add(t_emitter.contents, element);
    t_emitter.distr = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_button(col2_x, yy, "Set Region", col_width, eh, fa_center, null, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var ovx1 = col_width / 4;
    var ovy1 = 0;
    var ovx2 = col_width / 2;
    var ovy2 = eh;
    
    var element = create_input(col2_x, yy, "X1:", col_width, eh, ui_particle_emitter_xmin, 160, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmin = element;
    
    var element = create_input(col2_x + col_width / 2, yy, "Y1:", col_width, eh, ui_particle_emitter_ymin, 160, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymin = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "X2:", col_width, eh, ui_particle_emitter_xmax, 240, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmax = element;
    
    var element = create_input(col2_x + col_width / 2, yy, "Y2:", col_width, eh, ui_particle_emitter_ymax, 240, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymax = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col2_x, yy, "Streaming?", col_width, eh, ui_particle_emitter_streaming, false, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.streaming = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Rate", col_width, eh, ui_particle_emitter_rate, 120, "", validate_double, 0, 999, 5, vx1, vy1, vx2, vy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.rate = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "Burst", col_width, eh, fa_center, ui_particle_emitter_burst, t_emitter);
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: types
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Types", "<no particle types>", col_width, eh, 24, ui_particle_type_select, false, t_type, mode.types);
    element.entries_are = ListEntries.INSTANCES;
    t_type.list = element;
    ds_list_add(t_type.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Type", col_width, eh, fa_center, ui_particle_type_add, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Type", col_width, eh, fa_center, ui_particle_type_remove, t_type);
    ds_list_add(t_type.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", col_width, eh, ui_particle_type_rename, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.name = element;
    
    yy += element.height + spacing;
    
    var element = create_list(col2_x, yy, "Shape:", "", col_width, eh, 8, null, false, t_type);
    create_list_entries(element, "Pixel", "Disk", "Square", "Line", "Star", "Circle", "Ring", "Sphere", "Flare", "Spark", "Explosion", "Cloud", "Smoke", "Snow");
    ds_list_add(t_type.contents, element);
    t_type.shape = element;
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_text(col2_x, yy, "Movement", col_width, eh, fa_left, col_width, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Speed:", col_width, eh, null, 0, "pixels per frame", validate_double, -400, 400, 5, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.speed = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "More...", col_width, eh, fa_center, null, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Direction:", col_width, eh, null, 0, "", validate_double, -400, 400, 5, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.direction = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "More...", col_width, eh, fa_center, null, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Gravity:", col_width, eh, null, 0, "", validate_double, -400, 400, 5, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.gravity = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Grav. Dir:", col_width, eh, null, 270, "", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.gravity_direction = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Orientation:", col_width, eh, null, 0, "", validate_double, -400, 400, 5, vx1, vy1, vx2, vy2, t_type);
    ds_list_add(t_type.contents, element);
    t_type.orientation = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "More...", col_width, eh, fa_center, null, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Color", col_width, eh, fa_left, col_width, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Life and Death", col_width, eh, fa_left, col_width, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    return id;
}