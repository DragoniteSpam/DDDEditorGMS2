/// @param UIList

var data = guid_get(Camera.ui_game_data.active_type_guid);
var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var property_selection = argument0.entries[| ui_list_selection(argument0)].GUID;

if (selection >= 0) {
    // i tried chaining these together into one statement and it didn't work for some reason. fabulous.
    var instance = guid_get(data.instances[| selection].GUID);
    var list = ds_list_find_value(instance.values, argument0.key);
    // @todo the value list
    ds_list_replace(list, 0, property_selection);
}