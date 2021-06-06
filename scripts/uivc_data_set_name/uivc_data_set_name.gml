/// @param UIThing
function uivc_data_set_name(input) {

    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);

    if (selection + 1) {
        guid_get(data.instances[selection].GUID).name = input.value;
    }


}
