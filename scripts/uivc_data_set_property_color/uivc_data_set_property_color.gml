/// @param UIColorPicker
function uivc_data_set_property_color(argument0) {

    var picker = argument0;
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);

    if (selection + 1) {
        // @gml
        // because game maker can't handle doing all of these accessors in the same
        // line apparently
        var instance = data.instances[| selection];
        ds_list_set(instance.values[| picker.key], 0, picker.value);
    }


}
