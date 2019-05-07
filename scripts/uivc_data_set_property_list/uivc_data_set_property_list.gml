/// @description  void uivc_data_set_property_list(UIList);
/// @param UIList

var data=guid_get(Camera.ui_game_data.active_type_guid);
var selection=ui_list_selection(Camera.ui_game_data.el_instances);
var property_selection=argument0.entries[| ui_list_selection(argument0)].GUID;

if (selection>=0){
    // i tried chaining these together into one statement and it didn't work for some reason. fabulous.
    var instance=guid_get(data.instances[| selection].GUID);
    var list=instance.values;
    ds_list_replace(list, argument0.key, property_selection);
    //(guid_get(data.instances[| selection].GUID)).values[| argument0.key]=property_selection;
}
