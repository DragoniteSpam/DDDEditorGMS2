/// @param UIThing

var thing = argument0;

if (thing.root.selected_property) {
    var data = thing.root.selected_data;
    var index = ds_list_find_index(data.properties, thing.root.selected_property);
    ds_list_delete(data.properties, index);
    var instances = data.instances;
    for (var i = 0; i < ds_list_size(instances); i++) {
        ds_list_delete(instances[| i].values, index);
    }
    ui_list_deselect(thing.root.el_list_p);
}