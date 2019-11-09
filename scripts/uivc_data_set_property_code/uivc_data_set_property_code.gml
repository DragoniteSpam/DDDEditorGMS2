/// @param UIThing

var data = guid_get(Camera.Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Camera.Stuff.data.ui.el_instances);

if (selection >= 0) {
    // @todo gml
    // because game maker can't handle doing all of these accessors in the same
    // line apparently
    var instance = data.instances[| selection];
    ds_list_set(instance.values[| argument0.key], 0, argument0.value);
}