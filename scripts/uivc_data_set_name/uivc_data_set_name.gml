/// @description  void uivc_data_set_name(UIThing);
/// @param UIThing

var data=guid_get(Camera.ui_game_data.active_type_guid);
var selection=ui_list_selection(Camera.ui_game_data.el_instances);

if (selection<0){
    var instance=noone;
} else {
    var instance=guid_get(data.instances[| selection].GUID);
}

if (instance!=noone){
    instance.name=argument0.value;
}
