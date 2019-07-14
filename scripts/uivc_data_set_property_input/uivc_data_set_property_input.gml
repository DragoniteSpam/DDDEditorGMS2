/// @param UIThing

var data = guid_get(Camera.ui_game_data.active_type_guid);
var selection = ui_list_selection(Camera.ui_game_data.el_instances);

if (selection >= 0) {
    var instance = data.instances[| selection];
    // @todo bounds check?
    ds_list_set(instance.values[| argument0.key] ,0, script_execute(argument0.value_conversion, argument0.value));
}