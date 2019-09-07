/// @param UIThing

var thing = argument0;

// i really hope the garbage collector does its thing
ds_list_delete(thing.root.event.types, ui_list_selection(thing.root.el_list));
ui_list_clear(thing.root.el_list);