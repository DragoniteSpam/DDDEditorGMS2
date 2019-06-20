/// @param Dialog

var dw = 512;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings", dialog_default, dc_close_no_questions_asked, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var c2 = dw/2;

var yy = 64;

var el_gameplay_title = create_text(16, yy, "General Game Settings", ew, eh, fa_left, dw / 2, dg);
yy = yy + eh;
var el_gameplay_grid = create_checkbox(16, yy, "Snap Player to Grid", ew, eh, uivc_settings_game_grid, "", Stuff.game_player_grid, dg);
yy = yy + eh;
var el_battle_type = create_radio_array(16, yy, "Battle Style", ew, eh, uivc_settings_game_battle_style, Stuff.game_battle_style, dg);
create_radio_array_options(el_battle_type, "Team-based", "Melee");
yy = yy + ui_get_radio_array_height(el_battle_type) + eh;

// second column

yy = 64;

// todo some kind of indication of which map is supposed to be the starting map - perhaps give each
// element a "color" which the text is drawn with too

var el_map_list = create_list(c2 + 16, yy, "Identified Maps", "<no maps>", ew, eh, 8, null, false, dg);
dialog_create_settings_data_map_list(el_map_list);

dg.el_map_list = el_map_list;

yy = yy + eh + eh * 8 + eh / 2;

var el_map_delete = create_button(c2 + 16, yy, "Dereference", ew, eh, fa_middle, dmu_data_dereference, dg);

yy = yy + eh + eh / 2;

var el_map_starting = create_button(c2 + 16, yy, "Make Starting Map", ew, eh, fa_middle, dmu_data_starting_map, dg);

// confirm

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_gameplay_title, el_gameplay_grid, el_battle_type,
    el_map_list, el_map_delete, el_map_starting,
    el_confirm);

keyboard_string = "";

return dg;