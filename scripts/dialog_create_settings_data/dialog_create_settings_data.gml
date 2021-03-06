/// @param Dialog
function dialog_create_settings_data(argument0) {

    var dialog = argument0;

    var dw = 960;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Data Settings", dialog_default, dc_close_no_questions_asked, dialog);

    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var col1_x = dw * 0 / columns + spacing;
    var col2_x = dw * 1 / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;

    var yy = 64;

    var el_summary = create_input(col1_x, yy, "Summary:", dw - 64, eh, uivc_settings_game_file_summary, Stuff.game_file_summary, "Write a short description here", validate_string, 0, 1, 128, vx1, vy1, dw - 32, vy2, dg);
    el_summary.tooltip = "A quick summary of the game that the data files are to be used for; will be shown in the project list when you open the editor. Has no impact on gameplay (unless you code it to)."
    yy += el_summary.height + spacing;

    var yy_base = yy;

    var el_summary_author = create_input(col1_x, yy, "Author:", ew, eh, uivc_settings_game_file_author, Stuff.game_file_author, "Author", validate_string, 0, 1, 20, vx1, vy1, vx2, vy2, dg);
    el_summary_author.tooltip = "The name of the person who made this; will be shown in the project list when you open the editor. Has no impact on gameplay (unless you code it to) and is not a substitute for full game credits."
    yy += el_summary_author.height + spacing;

    var el_gameplay_title = create_text(col1_x, yy, "General Gameplay Settings", ew, eh, fa_left, dw / 2, dg);
    el_gameplay_title.color = c_blue;
    yy += el_gameplay_title.height + spacing
    ;
    var el_gameplay_grid = create_checkbox(col1_x, yy, "Snap Player to Grid", ew, eh, uivc_settings_game_grid, Stuff.game_player_grid, dg);
    el_gameplay_grid.tooltip = "Whether the player's position will be restricted to the grid, or whether they will be allowed to move freely between cells";
    yy += el_gameplay_grid.height + spacing;

    var el_player_start = create_button(col1_x, yy, "Player Starting Position", ew, eh, fa_center, dialog_create_settings_data_player_start, dg);
    el_player_start.tooltip = "Set the player's starting position on the map. By default it will be in the bottom-upper-left corner of the default map, but you probably want it to be somewhere with meaning.";
    yy += el_player_start.height + spacing;

    var el_graphics_title = create_text(col1_x, yy, "Graphical Settings", ew, eh, fa_left, dw / 2, dg);
    el_graphics_title.color = c_blue;
    yy += el_graphics_title.height + spacing

    var el_lighting_buckets = create_input(col1_x, yy, "Lighting levels:", ew, eh, uivc_settings_game_lighting_levels, Stuff.game_lighting_buckets, "float", validate_double, 1, 1000, 4, vx1, vy1, vx2, vy2, dg);
    el_lighting_buckets.tooltip = "The number of level of shading the lighting can have. Use a small number for a more cartoony lighting effect. Use a higher value for smoother lighting. A value over 100 is largely pointless, but this is a constant-time operation so you can go higher if you want.";
    yy += el_lighting_buckets.height + spacing;

    var el_lighting_default_ambient = create_color_picker(col1_x, yy, "Default ambient:", ew, eh, uivc_settings_game_lighting_default_ambient, Stuff.game_lighting_default_ambient, vx1, vy1, vx2, vy2, dg);
    el_lighting_default_ambient.tooltip = "The default ambient lighting color. New maps will use this value. Existing maps will not be updated.";
    yy += el_lighting_default_ambient.height + spacing;

    var el_screen_width = create_input(col1_x, yy, "Screen Width:", ew, eh, uivc_settings_game_base_screen_w, Stuff.game_screen_base_width, "signed short int", validate_int, -0x10000, 0xffff, 6, vx1, vy1, vx2, vy2, dg);
    el_screen_width.tooltip = "How you want the game to be scaled. If you are making a game that is primarily pixel art, you may want to use a base resolution such as 640x360 or 320x180. Set these to -1 if you do not want scaling.";
    dg.el_screen_width = el_screen_width;
    yy += el_screen_width.height + spacing;

    var el_screen_height = create_input(col1_x, yy, "Screen Height:", ew, eh, uivc_settings_game_base_screen_h, Stuff.game_screen_base_height, "signed short int", validate_int, -0x10000, 0xffff, 6, vx1, vy1, vx2, vy2, dg);
    el_screen_height.tooltip = el_screen_width.tooltip;
    dg.el_screen_height = el_screen_height;
    yy += el_screen_height.height + spacing;

    var el_screen_full = create_button(col1_x, yy, "Full", ew / 3, eh, fa_center, uivc_settings_game_base_screen_full, dg);
    var el_screen_320 = create_button(col1_x + ew / 3, yy, "320x180", ew / 3, eh, fa_center, uivc_settings_game_base_screen_320, dg);
    var el_screen_640 = create_button(col1_x + ew * 2 / 3, yy, "640x360", ew / 3, eh, fa_center, uivc_settings_game_base_screen_640, dg);
    yy += el_screen_640.height + spacing;

    var el_base_chunk_size = create_input(col1_x, yy, "Base Chunk Size:", ew, eh, uivc_settings_game_base_map_chunk_size, Stuff.game_base_map_chunk_size, "short int", validate_int, 16, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
    el_base_chunk_size.tooltip = "The default map chunk size";
    dg.el_base_chunk_size = el_base_chunk_size;
    yy += el_base_chunk_size.height + spacing;

    yy = yy_base;

    var el_global_title = create_text(col2_x, yy, "Variables and Stuff", ew, eh, fa_left, dw / 2, dg);
    el_global_title.color = c_blue;
    yy += el_global_title.height + spacing;

    var el_variables = create_button(col2_x, yy, "Global Variables", ew, eh, fa_center, dialog_create_settings_data_variables, dg);
    el_variables.tooltip = "A list of built-in variables which you may wish to modify during the game. You may set their default values here.";
    yy += el_variables.height + spacing;

    var el_switches = create_button(col2_x, yy, "Global Switches", ew, eh, fa_center, dialog_create_settings_data_switches, dg);
    el_switches.tooltip = "A list of built-in variables which you may wish to modify during the game. You may set their default values here.";
    yy += el_switches.height + spacing;

    var el_game_constants = create_button(col2_x, yy, "Game Constants", ew, eh, fa_center, dialog_create_settings_data_game_constants, dg);
    el_game_constants.tooltip = "A list of properties whose value will not change during the game. Examples might include things such as \"walk speed\" or \"default weather.\"";
    yy += el_game_constants.height + spacing;

    var el_trigger_title = create_text(col2_x, yy, "Conditional Triggers", ew, eh, fa_left, dw / 2, dg);
    el_trigger_title.color = c_blue;
    yy += el_trigger_title.height + spacing;

    var el_collision_triggers = create_button(col2_x, yy, "Collision Triggers", ew, eh, fa_center, dialog_create_settings_data_collision_triggers, dg);
    el_collision_triggers.tooltip = "In addition to the default collision trigger (Player contact) you may define your own.";
    yy += el_collision_triggers.height + spacing;

    var el_event_triggers = create_button(col2_x, yy, "Event Triggers", ew, eh, fa_center, dialog_create_settings_data_event_triggers, dg);
    el_event_triggers.tooltip = "In addition to the default event triggers (action button, player touch, etc) you may define your own, such as \"on contact with a magic spell\" or something.";
    yy += el_event_triggers.height + spacing;

    var el_asset_flags = create_button(col2_x, yy, "Asset Flags", ew, eh, fa_center, dialog_create_settings_data_asset_flags, dg);
    el_asset_flags.tooltip = "Some extra flags you can assign to various game assets.";
    yy += el_asset_flags.height + spacing;

    var el_common_code = create_text(col2_x, yy, "Common Code", ew, eh, fa_left, dw / 2, dg);
    el_common_code.color = c_blue;
    yy += el_common_code.height + spacing;

    var el_common_effect_code = create_input_code(col2_x, yy, "Effect Code:", ew, eh, vx1, vy1, vx2, vy2, Stuff.game_common_effect_code, uivc_settings_game_common_effect_code, dg);
    el_common_effect_code.tooltip = "Code for common effects you might want to call from anywhere in the game (flickering lights, similar particle systems, etc).";
    yy += el_common_effect_code.height + spacing;

    yy = yy_base;

    var el_edit_title = create_text(col3_x, yy, "Other Settings", ew, eh, fa_left, ew, dg);
    el_edit_title.color = c_blue;
    yy += el_edit_title.height + spacing;

    var el_edit_notes = create_input_code(col3_x, yy, "Game notes:", ew, eh, vx1, vy1, vx2, vy2, Stuff.game_notes, uivc_settings_game_notes, dg);
    el_edit_notes.tooltip = "This doesn't affect the game, but you may find it helpful to keep a set of notes for things you want to remember while working on it.";
    el_edit_notes.is_code = false;
    yy += el_edit_notes.height + spacing;

    var el_data_files = create_button(col3_x, yy, "Data and Asset Files", ew, eh, fa_center, dialog_create_settings_data_asset_files, dg);
    el_data_files.tooltip = "You may wish to separate different kinds of game assets into different data files. In fact, if you have a lot of them, you'll definitely want to do that, especially if you're on source control.";
    yy += el_data_files.height + spacing;

    yy = yy_base;

    // confirm
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_summary,
        el_summary_author,
        // gameplay
        el_gameplay_title,
        el_gameplay_grid,
        el_player_start,
        // graphics
        el_graphics_title,
        el_lighting_buckets,
        el_lighting_default_ambient,
        el_screen_width,
        el_screen_height,
        el_screen_full,
        el_screen_320,
        el_screen_640,
        el_base_chunk_size,
        // game variables and stuff
        el_global_title,
        el_variables,
        el_switches,
        el_game_constants,
        el_trigger_title,
        el_collision_triggers,
        el_event_triggers,
        el_asset_flags,
        // global code pieces
        el_common_code,
        el_common_effect_code,
        // other things
        el_edit_title,
        el_edit_notes,
        el_data_files,
        // confirm
        el_confirm
    );

    return dg;


}
