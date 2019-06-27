/// @param UIList

var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var pselection = ui_list_selection(argument0.root.el_list_main);
var data_selection = ui_list_selection(argument0);

if (pselection >= 0 && selection >= 0) {
    var data = guid_get(Camera.ui_game_data.active_type_guid);
    var instance = data.instances[| selection];
    var plist = instance.values[| argument0.key];
    
    plist[| pselection] = argument0.entries[| data_selection];
    
    argument0.root.el_list_main.entries[| pselection] = plist[| pselection];
}