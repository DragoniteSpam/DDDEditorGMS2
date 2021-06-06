function uivc_data_set_property_color(picker) {
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);

    if (selection + 1) {
        data.instances[@ selection].values[@ checkbox.key][@ 0] = picker.value;
    }
}