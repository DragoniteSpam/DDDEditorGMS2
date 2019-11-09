/// @param UIThing

var thing = argument0;

var data = guid_get(Camera.Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Camera.Stuff.data.ui.el_instances);

if (selection >= 0) {
    var instance = data.instances[| selection];
    // @todo bounds check
    // you need the value conversion here, since this is generic data
    ds_list_set(instance.values[| thing.key], 0, script_execute(thing.value_conversion, thing.value));
}