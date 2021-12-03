function dialog_create_refid_list(dialog, color, onvaluechange, node, index) {
    var dw = 640;
    var dh = 720;
    
    var dg = dialog_create(dw, dh, "Entities", dialog_default, dialog_destroy, dialog);
    dg.node = node;
    dg.index = index;
    
    var columns = 2;
    var ew = dw / columns - 32 * columns;
    var eh = 24;
    
    var c2 = dw / columns;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var spacing = 16;
    
    var source_ref = node.custom_data[index][0];
    var source_type = 2;
    switch (source_ref) {
        case REFID_PLAYER:      source_type = 0;    break;
        case REFID_SELF:        source_type = 1;    break;
    }
    
    dg.el_type = create_radio_array(16, yy, "Type:", ew, eh, null, source_type, dg);
    create_radio_array_options(dg.el_type, ["Player", "Self", "Entity"]);
    
    yy += dg.el_type.GetHeight() + spacing;
    
    dg.el_list = create_list(14, yy, "All Entities: " + string(ds_list_size(Stuff.map.active_map.contents.all_entities)),
        "<no entities>", ew, eh, 20, null, false, dg, Stuff.map.active_map.contents.all_entities);
    dg.el_list.entries_are = ListEntries.INSTANCES_REFID;
    for (var i = 0, n = ds_list_size(Stuff.map.active_map.contents.all_entities); i < n; i++) {
        if (Stuff.map.active_map.contents.all_entities[| i].REFID == source_ref) {
            ui_list_select(dg.el_list, i, true);
            has_been_set = true;
            break;
        }
    }
    
    var el_text = create_text(c2 + 16, dh / 2, "Only references to entities in the current map can be set.\n\n" +
    "If you try to access an entity reference that is not in the current map during the game, the node will be skipped.\n\n" +
    "If you set a reference in one map and edit the property while another is loaded, the value will be preserved but will not be named or appear in this list.\n\n" +
    "It is recommended that events that reference specific entities only be called from the maps which the entities exist in.\n\n" +
    "Leaving black will automatically refer to the calling entity.",
        ew, eh, fa_left, ew, dg);
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Good", b_width, b_height, fa_center, onvaluechange, dg);
    
    ds_list_add(
        dg.contents,
        dg.el_type,
        dg.el_list,
        el_text,
        el_confirm
    );
    
    return dg;
}