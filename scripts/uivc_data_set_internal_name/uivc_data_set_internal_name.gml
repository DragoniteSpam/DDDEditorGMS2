/// @param UIThing

var data = guid_get(Camera.ui_game_data.active_type_guid);
var selection = ui_list_selection(Camera.ui_game_data.el_instances);

if (selection >= 0) {
    var instance = data.instances[| selection];
    if (internal_name_get(argument0.value) == noone) {
        internal_name_set(instance, argument0.value);
    }
}