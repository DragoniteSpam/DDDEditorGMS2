/// @param UIThing

var thing = argument0;
var base_dialog = thing.root.root.root;

var data = thing.root.data_type;
var selection = ui_list_selection(base_dialog.el_instances);
var instance = data.instances[| selection];

if (data && instance && (selection > 0)) {
    ds_list_sort_name(data.instances);
    ui_list_deselect(base_dialog.el_instances);
}

dc_default(thing.root);