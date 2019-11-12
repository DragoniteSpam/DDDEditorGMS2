/// @param Dialog

var dialog = argument0;

var dw = 512;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings", dialog_default, dc_close_no_questions_asked, dialog);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var col1_x = 16;
var col2_x = dw / 2 + 16;
var spacing = 16;

var yy = 64;
var yy_base = yy;

var el_gameplay_title = create_text(col1_x, yy, "General Gameplay Settings", ew, eh, fa_left, dw / 2, dg);
yy = yy + el_gameplay_title.height + spacing;
var el_gameplay_grid = create_checkbox(col1_x, yy, "Snap Player to Grid", ew, eh, uivc_settings_game_grid, Stuff.game_player_grid, dg);
yy = yy + el_gameplay_grid.height + spacing;
var el_player_start = create_button(col1_x, yy, "Player Starting Position", ew, eh, fa_center, dialog_create_settings_data_player_start, dg);
yy = yy + el_player_start.height + spacing;
var el_battle_type = create_radio_array(col1_x, yy, "Battle Style", ew, eh, uivc_settings_game_battle_style, Stuff.game_battle_style, dg);
create_radio_array_options(el_battle_type, ["Team-based", "Grid-based"]);
yy = yy + ui_get_radio_array_height(el_battle_type) + spacing;

var el_edit_title = create_text(col1_x, yy, "Other Settings", ew, eh, fa_left, ew, dg);
yy = yy + el_edit_title.height + spacing;
var el_edit_include_terrain = create_checkbox(col1_x, yy, "Include Terrain?", ew, eh, uivc_settings_game_include_terrain, Stuff.game_include_terrain, dg);
yy = yy + el_edit_include_terrain.height + spacing;

yy = yy_base;

var el_global_title = create_text(col2_x, yy, "Variables and Stuff", ew, eh, fa_left, dw / 2, dg);
yy = yy + el_global_title.height + spacing;
var el_constants = create_button(col2_x, yy, "Global Constants", ew, eh, fa_center, not_yet_implemented, dg);
yy = yy + el_constants.height + spacing;
var el_variables = create_button(col2_x, yy, "Global Variables", ew, eh, fa_center, dialog_create_settings_data_variables, dg);
yy = yy + el_variables.height + spacing;
var el_switches = create_button(col2_x, yy, "Global Switches", ew, eh, fa_center, dialog_create_settings_data_switches, dg);
yy = yy + el_switches.height + spacing;
var el_event_triggers = create_button(col2_x, yy, "Event Triggers", ew, eh, fa_center, dialog_create_settings_data_event_triggers, dg);
yy = yy + el_event_triggers.height + spacing;
var el_game_constants = create_button(col2_x, yy, "Game Constants", ew, eh, fa_center, dialog_create_settings_data_game_constants, dg);
yy = yy + el_game_constants.height + spacing;

yy = yy_base;

// confirm
	
var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_gameplay_title, el_gameplay_grid, el_player_start, el_battle_type,
    el_edit_title, el_edit_include_terrain,
    el_global_title, el_constants, el_variables, el_switches, el_event_triggers, el_game_constants,
    el_confirm
);

return dg;