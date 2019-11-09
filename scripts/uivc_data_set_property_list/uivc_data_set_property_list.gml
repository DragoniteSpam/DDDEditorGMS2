/// @param UIList

var ui_list = argument0;

var data = guid_get(Camera.Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Camera.Stuff.data.ui.el_instances);
var property_selection = ui_list.entries[| ui_list_selection(ui_list)].GUID;

if (selection >= 0) {
    // i tried chaining these together into one statement and it didn't work for some reason. fabulous.
    var instance = guid_get(data.instances[| selection].GUID);
    var list = ds_list_find_value(instance.values, ui_list.key);
    // this is for when max size = 1 so no need to mess with the list
    ds_list_replace(list, 0, property_selection);
}