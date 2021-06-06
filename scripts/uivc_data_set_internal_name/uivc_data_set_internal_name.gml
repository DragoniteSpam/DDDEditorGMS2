/// @param UIThing
function uivc_data_set_internal_name(input) {

    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);

    if (selection + 1) {
        var instance = data.instances[selection];
        if (!internal_name_get(input.value)) {
            internal_name_set(instance, input.value);
        }
    }


}
