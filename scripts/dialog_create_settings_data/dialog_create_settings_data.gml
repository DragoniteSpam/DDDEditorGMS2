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

var c2 = dw/2;
var spacing = 16;

var yy = 64;
var yy_base = yy;

var el_gameplay_title = create_text(16, yy, "General Game Settings", ew, eh, fa_left, dw / 2, dg);
yy = yy + el_gameplay_title.height + spacing;
var el_gameplay_grid = create_checkbox(16, yy, "Snap Player to Grid", ew, eh, uivc_settings_game_grid, "", Stuff.game_player_grid, dg);
yy = yy + el_gameplay_grid.height + spacing;
var el_player_start = create_button(16, yy, "Player Starting Position", ew, eh, fa_center, dialog_create_settings_data_player_start, dg);
yy = yy + el_player_start.height + spacing;
var el_battle_type = create_radio_array(16, yy, "Battle Style", ew, eh, uivc_settings_game_battle_style, Stuff.game_battle_style, dg);
create_radio_array_options(el_battle_type, ["Team-based", "Grid-based"]);
yy = yy + ui_get_radio_array_height(el_battle_type) + spacing;

yy = yy_base;

var el_global_title = create_text(c2 + 16, yy, "Variables and Stuff", ew, eh, fa_left, dw / 2, dg);
yy = yy + el_global_title.height + spacing;
var el_constants = create_button(c2 + 16, yy, "Global Constants", ew, eh, fa_center, not_yet_implemented, dg);
yy = yy + el_constants.height + spacing;
var el_variables = create_button(c2 + 16, yy, "Global Variables", ew, eh, fa_center, dialog_create_settings_data_variables, dg);
yy = yy + el_variables.height + spacing;
var el_switches = create_button(c2 + 16, yy, "Global Switches", ew, eh, fa_center, dialog_create_settings_data_switches, dg);
yy = yy + el_switches.height + spacing;
var el_event_triggers = create_button(c2 + 16, yy, "Event Triggers", ew, eh, fa_center, dialog_create_settings_data_event_triggers, dg);
yy = yy + el_event_triggers.height + spacing;

yy = yy_base;

// confirm

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_gameplay_title, el_gameplay_grid, el_player_start, el_battle_type,
    el_global_title, el_constants, el_variables, el_switches, el_event_triggers,
    el_confirm);

return dg;