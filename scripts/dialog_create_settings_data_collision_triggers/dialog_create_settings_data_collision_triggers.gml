/// @param root
function dialog_create_settings_data_collision_triggers(argument0) {

    var dw = 320;
    var dh = 680;

    var root = argument0;

    var dg = dialog_create(dw, dh, "Data Settings: Collision Triggers", dialog_default, dc_close_no_questions_asked, root);

    var ew = dw - 64;
    var eh = 24;

    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var spacing = 16;

    var yy = 64;
    var yy_start = 64;

    var el_list = create_list(32, yy, "Collision Triggers", "", ew, eh, 20, uivc_list_selection_collision_triggers, false, dg, Stuff.all_collision_triggers);
    el_list.tooltip = "Any collision triggers you may want to use in the game. These are stored in the form of a 32-bit mask, which means you can use up to 32 of them and they may be toggled on or off independantly of each other.";
    el_list.numbered = true;
    el_list.allow_deselect = false;
    ui_list_select(el_list, 0);
    dg.el_list = el_list;

    yy += ui_get_list_height(el_list) + spacing;

    var el_name = create_input(32, yy, "Name:", ew, eh, uivc_global_collision_name, "", "16 characters", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    ui_input_set_value(el_name, Stuff.all_collision_triggers[| 0]);
    yy += el_name.height + spacing;
    dg.el_name = el_name;

    yy += el_name.height + spacing;

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_list,
        el_name,
        el_confirm
    );

    return dg;


}
