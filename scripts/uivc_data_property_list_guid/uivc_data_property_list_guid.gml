/// @param UIList

var list = argument0;

var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var pselection = ui_list_selection(list.root.el_list_main);
var data_selection = ui_list_selection(list);

if (pselection >= 0 && selection >= 0) {
    var data = guid_get(Camera.ui_game_data.active_type_guid);
    var instance = data.instances[| selection];
    var plist = instance.values[| list.key];
    
    plist[| pselection] = list.entries[| data_selection].GUID;
}