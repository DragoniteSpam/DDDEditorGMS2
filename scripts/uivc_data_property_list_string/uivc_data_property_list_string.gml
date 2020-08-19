/// @param UIInput
function uivc_data_property_list_string(argument0) {

    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    var pselection = ui_list_selection(argument0.root.el_list_main);
        
    if (pselection >= 0) {
        var data = guid_get(Stuff.data.ui.active_type_guid);
        var instance = guid_get(data.instances[| selection].GUID);
        var plist = instance.values[| argument0.key];
            
        plist[| pselection] = argument0.value;
            
        argument0.root.el_list_main.entries[| pselection] = argument0.value;
    }


}
