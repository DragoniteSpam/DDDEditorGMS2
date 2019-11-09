/// @param UIThing

var data = guid_get(Camera.Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Camera.Stuff.data.ui.el_instances);

if (selection < 0) {
    var instance = noone;
} else {
    var instance = guid_get(data.instances[| selection].GUID);
}

if (instance) {
    instance.name = argument0.value;
}