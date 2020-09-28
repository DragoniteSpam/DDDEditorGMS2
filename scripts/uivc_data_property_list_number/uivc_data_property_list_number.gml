/// @param UIInput
function uivc_data_property_list_number(argument0) {

    var input = argument0;

    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    var pselection = ui_list_selection(input.root.el_list_main);

    if (pselection >= 0) {
        var data = guid_get(Stuff.data.ui.active_type_guid);
        var instance = guid_get(data.instances[| selection].GUID);
        var plist = instance.values[| input.key];
    
        var rv = real(input.value);
        plist[| pselection] = rv;
    
        input.root.el_list_main.entries[| pselection] = string(rv);
    }


}
