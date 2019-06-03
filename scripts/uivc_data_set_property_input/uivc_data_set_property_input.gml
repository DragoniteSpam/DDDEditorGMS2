/// @description void uivc_data_set_property_input(UIThing);
/// @param UIThing

var data=guid_get(Camera.ui_game_data.active_type_guid);
var selection=ui_list_selection(Camera.ui_game_data.el_instances);

if (selection>=0) {
    var instance=data.instances[| selection];
    if (script_execute(argument0.validation, argument0.value)) {
        instance.values[| argument0.key]=script_execute(argument0.value_conversion, argument0.value);
    }
}
