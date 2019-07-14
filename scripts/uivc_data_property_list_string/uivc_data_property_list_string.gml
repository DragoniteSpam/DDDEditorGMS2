/// @param UIInput

var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var pselection = ui_list_selection(argument0.root.el_list_main);
        
if (pselection >= 0) {
    var data = guid_get(Camera.ui_game_data.active_type_guid);
    var instance = guid_get(data.instances[| selection].GUID);
    var plist = instance.values[| argument0.key];
            
    plist[| pselection] = argument0.value;
            
    argument0.root.el_list_main.entries[| pselection] = argument0.value;
}