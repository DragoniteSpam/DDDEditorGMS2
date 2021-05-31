/// @param UIButton
function dc_custom_event_set_data(argument0) {

    var list = argument0.root.el_list_main;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var property = guid_get(list.node.custom_guid).types[| list.property_index];
        var type = guid_get(property[EventNodeCustomData.TYPE_GUID]);
    
        switch (type.type) {
            case DataTypes.ENUM: list.node.custom_data[@ list.property_index][@ list.multi_index] = type.properties[| selection].GUID; break;
            case DataTypes.DATA: list.node.custom_data[@ list.property_index][@ list.multi_index] = type.instances[| selection].GUID; break;
        }
    }

    dialog_destroy();


}
