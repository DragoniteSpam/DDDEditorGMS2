/// @param UIThing

var thing = argument0;

if (ds_list_size(Stuff.all_data) < 10000) {
    instance_deactivate_object(instance_create_depth(0, 0, 0, DataData));
    ui_list_deselect(thing.root.el_list_main);
    thing.root.selected_data = noone;
    thing.root.selected_property = noone;
    
    thing.root.changed = true;
    
    dialog_data_type_disable(thing.root);
} else {
    dialog_create_notice(thing.root, "Please don't try to create more than ten thousand generic data types. Bad things will happen. Why do you even want that many?", "Hey!");
}