/// @param Dialog
function dialog_create_settings_data_player_start(argument0) {

    var dw = 640;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Data Settings: Player Starting Location", dialog_default, dc_close_no_questions_asked, argument0);

    var columns = 2;
    var ew = dw / columns - 64;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var c2 = dw / columns;
    var spacing = 16;

    var yy = 64;
    var yy_start = 64;

    var starting = guid_get(Stuff.game_starting_map);

    var el_list_map = create_list(32, yy, "Map:", "<how did you manage that?>", ew, eh, 16, uivc_settings_game_start_map, false, dg, Stuff.all_maps);
    for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
        if (Stuff.game_starting_map == Stuff.all_maps[| i].GUID) {
            ui_list_select(el_list_map, i);
            break;
        }
    }
    el_list_map.entries_are = ListEntries.INSTANCES;
    yy += ui_get_list_height(el_list_map) + spacing;

    yy = yy_start;

    var el_x = create_input(c2 + 32, yy, "X:", ew, eh, uivc_settings_game_start_x, Stuff.game_starting_x, "x coordinate", validate_int, 0, starting.xx, 5, vx1, vy1, vx2, vy2, dg);
    dg.el_x = el_x;
    yy += el_x.height + spacing;

    var el_y = create_input(c2 + 32, yy, "Y:", ew, eh, uivc_settings_game_start_y, Stuff.game_starting_y, "y coordinate", validate_int, 0, starting.yy, 5, vx1, vy1, vx2, vy2, dg);
    dg.el_y = el_y;
    yy += el_y.height + spacing;

    var el_z = create_input(c2 + 32, yy, "Z:", ew, eh, uivc_settings_game_start_z, Stuff.game_starting_z, "z coordinate", validate_int, 0, starting.zz, 5, vx1, vy1, vx2, vy2, dg);
    dg.el_z = el_z;
    yy += el_z.height + spacing;

    var el_direction = create_radio_array(c2 + 32, yy, "Direction:", ew, eh, uivc_settings_game_start_direction, Stuff.game_starting_direction, dg);
    create_radio_array_options(el_direction, ["Down", "Left", "Right", "Up"]);

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_list_map, el_x, el_y, el_z, el_direction,
        el_confirm
    );

    return dg;


}
