/// @param EditorModeSpart

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIMain)) {
    #macro PART_MAXIMUM_EMITTERS 8
    #macro PART_MAXIMUM_TYPES 255
    
    home_row_y = 64;
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
    element.tooltip = "The background color.";
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col1_x, yy, "Automatic Update?", ew, eh, ui_particle_automatic_update, mode.system_auto_update, t_system);
    element.tooltip = "Whehter or not the particle system will update automatically. If this is turned off, you must update the system manually.";
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Update", ew, eh, fa_center, ui_particle_manual_update, t_system);
    element.tooltip = "Update the particle system by one step.";
    element.interactive = !mode.system_auto_update;
    ds_list_add(t_system.contents, element);
    t_system.manual_update = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Clear All Particles", ew, eh, fa_center, ui_particle_clear_particles, t_system);
    element.tooltip = "Clear all particles currently in the system.";
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Reset System", ew, eh, fa_center, ui_particle_reset, t_system);
    element.tooltip = "Destroy all particle types and emitters.";
    ds_list_add(t_system.contents, element);
    
    yy += element.height + spacing;
    #endregion
    
    #region tab: emitters
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Emitters", "<no emitters>", ew, eh, 26, ui_particle_emitter_select, false, t_emitter, mode.emitters);
    element.tooltip = "All of the currently-defined emitters types.";
    element.entries_are = ListEntries.INSTANCES;
    t_emitter.list = element;
    ds_list_add(t_emitter.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Emitter", ew, eh, fa_center, ui_particle_emitter_add, t_emitter);
    element.tooltip = "Add a particle emitter.";
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Emitter", ew, eh, fa_center, ui_particle_emitter_remove, t_emitter);
    element.tooltip = "Remove a particle emitter.";
    ds_list_add(t_emitter.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", ew, eh, ui_particle_emitter_rename, "Part Emitter", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_emitter);
    ds_list_add(t_emitter.contents, element);
    t_emitter.name = element;
    
    yy += element.height + spacing;
    
    var element = create_radio_array(col2_x, yy, "Shape:", ew, eh, ui_particle_emitter_shape, PartEmitterShapes.ELLIPSE, t_emitter);
    create_radio_array_options(element, ["Rectangle", "Ellipse", "Diamond", "Line"]);
    element.tooltip = "The shape of the emitter, stretched between the start and end points.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.shape = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_radio_array(col2_x, yy, "Distribution:", ew, eh, ui_particle_emitter_distribution, PartEmitterDistributions.LINEAR, t_emitter);
    create_radio_array_options(element, ["Linear", "Gaussian", "Inverse Gaussian"]);
    element.tooltip = "How the particles are distributed over the emission region.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.distr = element;
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    var element = create_button(col2_x, yy, "Set Region", ew, eh, fa_center, null, t_emitter);
    element.tooltip = "Set the emission region by clicking on the particle view.";
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    var ovx1 = ew / 4;
    var ovy1 = 0;
    var ovx2 = ew / 2;
    var ovy2 = eh;
    
    var element = create_input(col2_x, yy, "X1:", ew, eh, ui_particle_emitter_xmin, 160, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    element.tooltip = "The lower bound of the emission region.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmin = element;
    
    var element = create_input(col2_x + ew / 2, yy, "Y1:", ew, eh, ui_particle_emitter_ymin, 160, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    element.tooltip = "The lower bound of the emission region.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymin = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "X2:", ew, eh, ui_particle_emitter_xmax, 240, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    element.tooltip = "The upper bound of the emission region.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.xmax = element;
    
    var element = create_input(col2_x + ew / 2, yy, "Y2:", ew, eh, ui_particle_emitter_ymax, 240, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
    element.tooltip = "The upper bound of the emission region.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.ymax = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col2_x, yy, "Streaming?", ew, eh, ui_particle_emitter_streaming, false, t_emitter);
    element.tooltip = "Whether or not the emitter is currently streaming particles.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.streaming = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Rate", ew, eh, ui_particle_emitter_rate, 120, "", validate_double, 0, 999, 5, vx1, vy1, vx2, vy2, t_emitter);
    element.tooltip = "How many particles will be emitted per second. If you create a burst, this will be the number of particles created at once.";
    ds_list_add(t_emitter.contents, element);
    t_emitter.rate = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col2_x, yy, "Burst", ew, eh, fa_center, ui_particle_emitter_burst, t_emitter);
    element.tooltip = "Create a one-time burst of particles. The number of particles created is defined by the emission rate. Right-click in the paricle view to create a burst at the position of the mouse.";
    ds_list_add(t_emitter.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: types
    var yy = legal_y + spacing;
    
    var element = create_list(col1_x, yy, "Particle Types", "<no particle types>", ew, eh, 26, ui_particle_type_select, false, t_type, mode.types);
    element.tooltip = "All of the currently-defined particle types.";
    element.entries_are = ListEntries.INSTANCES;
    t_type.list = element;
    ds_list_add(t_type.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_button(col1_x, yy, "Add Type", ew, eh, fa_center, ui_particle_type_add, t_type);
    element.tooltip = "Add a particle type.";
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_button(col1_x, yy, "Remove Type", ew, eh, fa_center, ui_particle_type_remove, t_type);
    element.tooltip = "Remove a particle type. Any references to the particle type elsewhere will be reset.";
    ds_list_add(t_type.contents, element);
    
    yy = legal_y + spacing;
    
    var element = create_input(col2_x, yy, "Name:", ew, eh, ui_particle_type_rename, "Part Type", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The name of the particle type.";
    ds_list_add(t_type.contents, element);
    t_type.name = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Motion", ew, eh, fa_left, ew, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Speed:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "min:", ew, eh, ui_particle_type_speed_min, 160, "float", validate_double, -400, 400, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The minimum starting speed of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.speed_min = element;
    
    var element = create_input(col2_x + ew / 2, yy, "max:", ew, eh, ui_particle_type_speed_max, 160, "float", validate_double, -400, 400, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The maximum starting speed of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.speed_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, ui_particle_type_speed_incr, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much the particle speed should increase or decrease each update.";
    ds_list_add(t_type.contents, element);
    t_type.speed_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, ui_particle_type_speed_wiggle, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much should randomly be added or subtracted to particle speed each update.";
    ds_list_add(t_type.contents, element);
    t_type.speed_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Direction:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, ui_particle_type_direction_min, 4, 0.5, t_type);
    element.tooltip = "The minimum starting direction of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.direction_min = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, ui_particle_type_direction_max, 4, 0.5, t_type);
    element.tooltip = "The maximum starting direction of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.direction_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, ui_particle_type_direction_incr, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much the particle direction should increase or decrease each update.";
    ds_list_add(t_type.contents, element);
    t_type.direction_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, ui_particle_type_direction_wiggle, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much should randomly be added or subtracted to particle direction each update.";
    ds_list_add(t_type.contents, element);
    t_type.direction_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "Rotation:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, ui_particle_type_rotation_min, 4, 0.5, t_type);
    element.tooltip = "The minimum starting rotation of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.orientation_min = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, ui_particle_type_rotation_max, 4, 0.5, t_type);
    element.tooltip = "The maximum starting rotation of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.orientation_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "incr:", ew, eh, ui_particle_type_rotation_incr, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much the particle orientation should increase or decrease each update.";
    ds_list_add(t_type.contents, element);
    t_type.orientation_incr = element;
    
    var element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, ui_particle_type_rotation_wiggle, 0, "float", validate_double, -100, 100, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much should randomly be added or subtracted to particle orientation each update.";
    ds_list_add(t_type.contents, element);
    t_type.orientation_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col2_x, yy, "Relative?", ew, eh, ui_particle_type_rotation_relative, false, t_type);
    element.tooltip = "Whether the particle's rotation is relative to its direction of motion or not.";
    ds_list_add(t_type.contents, element);
    t_type.orientation_relative = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col2_x, yy, "Gravity:", ew, eh, ui_particle_type_gravity, 0, "float", validate_double, 0, 10, 3, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The strength of gravity acting on the particle, in pixels per step.";
    ds_list_add(t_type.contents, element);
    t_type.gravity = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col2_x, yy, "direction:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    var element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, ui_particle_type_gravity_direction, 4, 0.5, t_type);
    element.tooltip = "The minimum starting rotation of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.gravity_direction = element;
    
    yy = legal_y + spacing;
    
    var element = create_text(col3_x, yy, "Graphics", ew, eh, fa_left, ew, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_list(col3_x, yy, "Shape:", "", ew, eh, 6, ui_particle_type_shape, false, t_type);
    create_list_entries(element, "Pixel", "Disk", "Square", "Line", "Star", "Circle", "Ring", "Sphere", "Flare", "Spark", "Explosion", "Cloud", "Smoke", "Snow");
    element.tooltip = "The shape of the particle type. (Support for custom particle sprites may be added later.)";
    ds_list_add(t_type.contents, element);
    t_type.shape = element;
    
    yy += ui_get_list_height(element) + spacing;
    
    var element = create_color_picker(col3_x, yy, "Color 1A:", ew, eh, ui_particle_type_color_1a, c_white, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The beginning range of colors the particle may be at the beginning of its lifetime. (If multiple colors are disabled, it will be the only color.)";
    element.allow_alpha = true;
    ds_list_add(t_type.contents, element);
    t_type.base_color_1a = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col3_x - spacing, yy, "", 64, eh, ui_particle_type_color_1b_enabled, false, t_type);
    element.tooltip = "Enable or disable starting color range. (Enabling staring color range will override color transitions.)";
    ds_list_add(t_type.contents, element);
    t_type.base_color_1b_enabled = element;
    
    var element = create_color_picker(col3_x, yy, "        1B:", ew, eh, ui_particle_type_color_1b, c_white, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The end range of colors the particle may be at the beginning of its lifetime. (Color ranges do not support alpha.)";
    ds_list_add(t_type.contents, element);
    t_type.base_color_1b = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col3_x - spacing, yy, "", 64, eh, ui_particle_type_color_2_enabled, false, t_type);
    element.tooltip = "Enable or disable two-color transition. (Enabling staring color range will override color transitions.)";
    ds_list_add(t_type.contents, element);
    t_type.base_color_2_enabled = element;
    
    var element = create_color_picker(col3_x, yy, "        2:", ew, eh, ui_particle_type_color_2, c_white, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The color the particle will be halfway through its lifetime.";
    element.allow_alpha = true;
    ds_list_add(t_type.contents, element);
    t_type.base_color_2 = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col3_x - spacing, yy, "", 64, eh, ui_particle_type_color_3_enabled, false, t_type);
    element.tooltip = "Enable or disable three-color transition. (Enabling staring color range will override color transitions.)";
    ds_list_add(t_type.contents, element);
    t_type.base_color_3_enabled = element;
    
    var element = create_color_picker(col3_x, yy, "        3:", ew, eh, ui_particle_type_color_3, c_white, vx1, vy1, vx2, vy2, t_type);
    element.tooltip = "The color the particle will be at the end of its lifetime.";
    element.allow_alpha = true;
    ds_list_add(t_type.contents, element);
    t_type.base_color_3 = element;
    
    yy += element.height + spacing;
    
    var element = create_checkbox(col3_x, yy, "Additive blending?", ew, eh, ui_particle_type_color_additive, false, t_type);
    element.tooltip = "Enable or disable additive color blending.";
    ds_list_add(t_type.contents, element);
    t_type.additive_blending = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col3_x, yy, "Base Scale:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col3_x, yy, "x:", ew, eh, ui_particle_type_scale_x, 1, "float", validate_double, 0, 40, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The horizontal scale of the particle, before particle size (below) is applied.";
    ds_list_add(t_type.contents, element);
    t_type.xscale = element;
    
    var element = create_input(col3_x + ew / 2, yy, "y:", ew, eh, ui_particle_type_scale_y, 1, "float", validate_double, 0, 40, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The vertical scale of the particle, before particle size (below) is applied.";
    ds_list_add(t_type.contents, element);
    t_type.yscale = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col3_x, yy, "Size:", ew, eh, fa_left, ew, t_type);
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col3_x, yy, "min:", ew, eh, ui_particle_type_size_min, 1, "float", validate_double, 0, 40, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The minimum starting size of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.size_min = element;
    
    var element = create_input(col3_x + ew / 2, yy, "max:", ew, eh, ui_particle_type_size_max, 1, "float", validate_double, 0, 40, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The maximum starting size of the particle.";
    ds_list_add(t_type.contents, element);
    t_type.size_max = element;
    
    yy += element.height + spacing;
    
    var element = create_input(col3_x, yy, "incr:", ew, eh, ui_particle_type_size_incr, 0, "float", validate_double, -10, 10, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much the particle size should increase or decrease each update.";
    ds_list_add(t_type.contents, element);
    t_type.size_incr = element;
    
    var element = create_input(col3_x + ew / 2, yy, "wgl:", ew, eh, ui_particle_type_size_wiggle, 0, "float", validate_double, -10, 10, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "How much should randomly be added or subtracted to particle size each update.";
    ds_list_add(t_type.contents, element);
    t_type.size_wiggle = element;
    
    yy += element.height + spacing;
    
    var element = create_text(col3_x, yy, "Life and Death", ew, eh, fa_left, ew, t_type);
    element.color = c_blue;
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    var element = create_input(col3_x, yy, "min:", ew, eh, ui_particle_type_life_min, 10, "float", validate_double, 0.1, 60, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The minimum lifetime of the particle type, in seconds.";
    ds_list_add(t_type.contents, element);
    t_type.life_min = element;
    
    var element = create_input(col3_x + ew / 2, yy, "max:", ew, eh, ui_particle_type_life_max, 10, "float", validate_double, 0.1, 60, 4, ovx1, ovy1, ovx2, ovy2, t_type);
    element.tooltip = "The maximum lifetime of the particle type, in seconds.";
    ds_list_add(t_type.contents, element);
    t_type.life_max = element;
    
    yy += element.height + spacing;
    
    var element = create_button(col3_x, yy, "Secondary Emission", ew, eh, fa_center, null, t_type);
    element.tooltip = "Particles can emit other particles when they update, or upon death.";
    ds_list_add(t_type.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    return id;
}