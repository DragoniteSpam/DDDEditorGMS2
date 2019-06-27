/// @param UIThing

var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var data = guid_get(Camera.ui_game_data.active_type_guid);
var instance = guid_get(data.instances[| selection].GUID);
var plist = instance.values[| argument0.key];
var pselection = ui_list_selection(argument0.root.el_list_main);

if (pselection >= 0 && ds_list_size(plist) > 1) {
    ds_list_delete(plist, pselection);
    ds_list_delete(argument0.root.el_list_main.entries, pselection);
    ui_list_deselect(argument0.root.el_list_main);
}