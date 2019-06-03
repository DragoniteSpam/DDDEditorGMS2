/// @description void omu_event_custom_remove_property(UIThing);
/// @param UIThing

// i really hope the garbage collector does its thing
ds_list_delete(argument0.root.event.types, ui_list_selection(argument0.root.el_list));
ui_list_clear(argument0.root.el_list);
