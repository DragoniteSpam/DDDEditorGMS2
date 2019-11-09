/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(Stuff.data.ui.el_instances);
var data = guid_get(Stuff.data.ui.active_type_guid);
var instance = guid_get(data.instances[| selection].GUID);
var plist = instance.values[| thing.key];
var pselection = ui_list_selection(thing.root.el_list_main);

if (pselection >= 0 && ds_list_size(plist) > 1) {
    ds_list_delete(plist, pselection);
    ds_list_delete(thing.root.el_list_main.entries, pselection);
}