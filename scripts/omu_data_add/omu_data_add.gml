/// @param UIThing

var thing = argument0;

if (ds_list_size(Stuff.all_data) < 1000) {
    instance_deactivate_object(instantiate(DataData));
    ds_map_clear(thing.root.el_list_main.selected_entries);
    thing.root.selected_data = noone;
    thing.root.selected_property = noone;
    
    thing.root.changed = true;
    
    dialog_data_type_disable(thing.root);
} else {
    dialog_create_notice(thing.root, "Please don't try to create more than a thousand generic data types. Bad things will happen. Why do you even want that many?", "Hey!");
}