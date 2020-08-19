/// @param UIThing
function uivc_data_set_internal_name(argument0) {

    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);

    if (selection >= 0) {
        var instance = data.instances[| selection];
        if (!internal_name_get(argument0.value)) {
            internal_name_set(instance, argument0.value);
        }
    }


}
