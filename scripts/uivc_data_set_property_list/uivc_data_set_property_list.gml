function uivc_data_set_property_list(list) {
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(list);
    
    var instance_selection = ui_list_selection(Stuff.data.ui.el_instances);
    if (instance_selection + 1) {
        var instance = guid_get(data.instances[instance_selection].GUID);
        if (selection + 1) {
            // this is for when max size = 1 so no need to mess with the list
            instance.values[@ list.key][@ 0] = list.entries[| selection].GUID;
        } else {
            instance.values[@ list.key][@ 0] = NULL;
        }
    }
}