/// @param UIThing

var base_dialog = argument0.root.root.root.root;
// selection is guaranteed to have a value at this point
var selection = ui_list_selection(base_dialog.el_list);
var property = base_dialog.event.types[| selection];
property[@ 1] = argument0.value;

uivc_list_event_custom_property(base_dialog.el_list);