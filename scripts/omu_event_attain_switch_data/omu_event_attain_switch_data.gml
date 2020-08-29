function omu_event_attain_switch_data(thing, event_node, data_index) {
    // going to just put all of the available properties in here, i think, because that
    // should make some things a bit easier

    var dw = 320;
    var dh = 560;

    var dg = dialog_create(dw, dh, "Modify Global Switch", dialog_default, dc_close_no_questions_asked, thing);
    dg.node = event_node;
    dg.index = data_index;

    var custom_data_switch = event_node.custom_data[| 0];
    var custom_data_state = event_node.custom_data[| 1];

    var ew = dw - 64;
    var eh = 24;

    var yy = 64;
    var spacing = 16;

    var el_list = create_list(16, yy, "Switches", "<no switches>", ew, eh, 14, uivc_list_event_attain_switch_index, false, dg);
    for (var i = 0; i < ds_list_size(Stuff.switches); i++) {
        create_list_entries(el_list, Stuff.switches[| i][0]);
    }
    if (custom_data_switch[| 0] > -1) {
        ui_list_select(el_list, custom_data_switch[| 0]);
    }
    dg.el_list = el_list;

    yy += ui_get_list_height(el_list) + spacing;

    var el_state = create_checkbox(16, yy, "Enabled?", ew, eh, uivc_check_event_attain_switch_state, custom_data_state[|0], dg);
    dg.el_state = el_state;

    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_list,
        el_state,
        el_close
    );
    
    return dg;
}