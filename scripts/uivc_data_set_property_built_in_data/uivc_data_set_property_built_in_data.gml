function uivc_data_set_property_built_in_data(list) {
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    var data_selection = ui_list_selection(list);

    if (selection + 1) {
        var instance = data.instances[| selection];
        if (data_selection + 1) {
            ds_list_set(instance.values[| list.key], 0, list.entries[| data_selection].GUID);
        } else {
            ds_list_set(instance.values[| list.key], 0, 0);
        }
    }
}