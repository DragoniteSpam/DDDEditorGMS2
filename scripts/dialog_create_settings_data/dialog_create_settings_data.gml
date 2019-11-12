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
el_gameplay_grid.tooltip = "Whether the player's position will be restricted to the grid, or whether they will be allowed to move freely between cells";
yy = yy + el_gameplay_grid.height + spacing;
var el_player_start = create_button(col1_x, yy, "Player Starting Position", ew, eh, fa_center, dialog_create_settings_data_player_start, dg);
el_player_start.tooltip = "Set the player's starting position on the map. By default it will be in the bottom-upper-left corner of the default map, but you probably want it to be somewhere with meaning.";
yy = yy + el_player_start.height + spacing;
var el_battle_type = create_radio_array(col1_x, yy, "Battle Style", ew, eh, uivc_settings_game_battle_style, Stuff.game_battle_style, dg);
el_battle_type.tooltip = "Whether the default battle system should be team-based, or should allow contestants to wander around on the battlefield.";
create_radio_array_options(el_battle_type, ["Team-based", "Grid-based"]);
yy = yy + ui_get_radio_array_height(el_battle_type) + spacing;

var el_edit_title = create_text(col1_x, yy, "Other Settings", ew, eh, fa_left, ew, dg);
yy = yy + el_edit_title.height + spacing;
var el_edit_include_terrain = create_checkbox(col1_x, yy, "Include Terrain?", ew, eh, uivc_settings_game_include_terrain, Stuff.game_include_terrain, dg);
el_edit_include_terrain.tooltip = "It can be handy to save the terrain you are working on to the data file, but this can be very expensive space-wise. By default, this is off.";
yy = yy + el_edit_include_terrain.height + spacing;

yy = yy_base;

var el_global_title = create_text(col2_x, yy, "Variables and Stuff", ew, eh, fa_left, dw / 2, dg);
yy = yy + el_global_title.height + spacing;
var el_constants = create_button(col2_x, yy, "Global Constants", ew, eh, fa_center, not_yet_implemented, dg);
el_constants.tooltip = "";
yy = yy + el_constants.height + spacing;
var el_variables = create_button(col2_x, yy, "Global Variables", ew, eh, fa_center, dialog_create_settings_data_variables, dg);
el_variables.tooltip = "A list of built-in variables which you may wish to modify during the game. You may set their default values here.";
yy = yy + el_variables.height + spacing;
var el_switches = create_button(col2_x, yy, "Global Switches", ew, eh, fa_center, dialog_create_settings_data_switches, dg);
el_switches.tooltip = "A list of built-in variables which you may wish to modify during the game. You may set their default values here.";
yy = yy + el_switches.height + spacing;
var el_event_triggers = create_button(col2_x, yy, "Event Triggers", ew, eh, fa_center, dialog_create_settings_data_event_triggers, dg);
el_event_triggers.tooltip = "In addition to the default event triggers (action button, player touch, etc) you may define your own, such as \"on contact with a magic spell\" or something.";
yy = yy + el_event_triggers.height + spacing;
var el_game_constants = create_button(col2_x, yy, "Game Constants", ew, eh, fa_center, dialog_create_settings_data_game_constants, dg);
el_game_constants.tooltip = "A list of properties whose value will not change during the game. Examples might include things such as \"walk speed\" or \"default weather.\"";
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