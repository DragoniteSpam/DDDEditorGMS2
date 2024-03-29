function omu_event_attain_mesh_anim_end_action(thing, event_node, data_index) {
    // going to just put all of the available properties in here, i think, because that
    // should make some things a bit easier
    var dw = 320;
    var dh = 320;
    
    var dg = dialog_create(dw, dh, "Mesh Animation Settings", dialog_default, dialog_destroy, thing);
    dg.node = event_node;
    dg.index = data_index;
    
    // entity isn't going to be set here, because that's a pain in the butt
    var custom_data_speed = event_node.custom_data[1];
    var custom_data_endaction = event_node.custom_data[2];
    
    var ew = dw - 64;
    var eh = 24;
    
    var vx1 = dw / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + (ew - vx1);
    var vy2 = eh;
    
    var yy = 64;
    var spacing = 16;
    
    var el_speed = create_input(16, yy, "Speed:", ew, eh, uivc_list_event_attain_entity_mesh_anim_speed, custom_data_speed[0], "Frames per second", validate_int, -60, 60, 3, vx1, vy1, vx2, vy2, dg);
    
    yy += el_speed.height + spacing;
    
    var el_end_action = create_radio_array(16, yy, "Animation End Action", ew, eh, uivc_list_event_attain_entity_mesh_anim_end_action, custom_data_endaction[0], dg);
    create_radio_array_options(el_end_action, global.animation_end_action_names);
    
    yy += el_end_action.GetHeight() + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_speed,
        el_end_action,
        el_close
    );
    
    return dg;
}