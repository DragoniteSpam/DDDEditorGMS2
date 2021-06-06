function dialog_create_event_node_custom_data(dialog, node, property_index, multi_index) {
    var property = guid_get(node.custom_guid).types[| property_index];
    var type = guid_get(property[EventNodeCustomData.TYPE_GUID]);
    
    var dw = 320;
    var dh = 640;
    
    // todo cache the custom event and only commit the changes when you're done
    var dg = dialog_create(dw, dh, "Data Type: " + type.name, dialog_default, dialog_destroy, dialog);
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var b_width = 128;
    var b_height = 32;
    
    var n_slots = 20;
    
    var yy = 64;
    
    var el_list = create_list(16, yy, type.name, "<none found>", ew, eh, n_slots, null, false, dg, []);
    el_list.entries = (type.type == DataTypes.ENUM) ? type.properties : type.instances;
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.node = node;
    el_list.property_index = property_index;
    el_list.multi_index = multi_index;
    
    dg.el_list_main = el_list;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_custom_event_set_data, dg);
    dg.el_confirm = el_confirm;
    
    ds_list_add(dg.contents,
        el_list,
        el_confirm
    );
    
    return dg;
}